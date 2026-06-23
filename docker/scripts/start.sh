#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT="${1:-}"

cd "$DOCKER_DIR"

# Detect compose command: prefer v2 plugin, fall back to v1 standalone
if docker compose version >/dev/null 2>&1; then
    DC=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
    DC=(docker-compose)
else
    echo "Error: docker compose plugin or docker-compose not found"
    exit 1
fi

# Source env files into shell; compose inherits from environment
set -a
. "$DOCKER_DIR/.env"
if [ -n "$PROJECT" ]; then
    PROJECT_DIR="$DOCKER_DIR/projects/$PROJECT"
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "Error: project '$PROJECT' not found at $PROJECT_DIR"
        exit 1
    fi
    . "$PROJECT_DIR/.env"
fi
set +a

if [ -n "$PROJECT" ]; then
    cp "$PROJECT_DIR/nginx/default.conf" "$DOCKER_DIR/gaisoft/nginx/conf.d/default.conf"
    echo "✓ nginx config copied from projects/$PROJECT/"
elif [ -f "$DOCKER_DIR/nginx/default.conf" ]; then
    cp "$DOCKER_DIR/nginx/default.conf" "$DOCKER_DIR/gaisoft/nginx/conf.d/default.conf"
    echo "✓ nginx config copied from docker/nginx/default.conf"
fi

mkdir -p "$DOCKER_DIR/logs"
LOG="$DOCKER_DIR/logs/deploy-$(date +%Y%m%d-%H%M%S).log"
echo "Deploy log: $LOG"

"${DC[@]}" up -d 2>&1 | tee -a "$LOG"

# ── Post-start: seed ragflow auth ────────────────────────────────────────────
# rag_flow.{user,tenant,api_token,tenant_llm} tables are created by ragflow-server
# on its first boot (peewee), NOT during mysql initdb. So this seed must run AFTER
# ragflow-server is healthy — it cannot live in /docker-entrypoint-initdb.d.
# Idempotent (ON DUPLICATE KEY UPDATE), safe to re-run on every start.
SEED_FILE="/docker-entrypoint-initdb.d/post-seed/seed-ragflow-user.sql"
echo "Waiting for ragflow-server to become healthy (then seed ragflow auth)..." | tee -a "$LOG"
st=starting
for _ in $(seq 1 60); do
    st=$(docker inspect -f '{{.State.Health.Status}}' ragflow-server 2>/dev/null || echo starting)
    [ "$st" = "healthy" ] && break
    sleep 5
done
if [ "$st" = "healthy" ]; then
    # Capture seed stderr/stdout into the deploy log so failures are diagnosable
    if docker exec ragflow-mysql sh -c "mysql -uroot -p'${MYSQL_PASSWORD}' < $SEED_FILE" >>"$LOG" 2>&1; then
        echo "✓ ragflow auth seeded (user / tenant / api_token / local embedding)" | tee -a "$LOG"
    else
        echo "✗ ragflow seed FAILED — see $LOG ; retry: docker exec ragflow-mysql sh -c \"mysql -uroot -p\$MYSQL_PASSWORD < $SEED_FILE\"" | tee -a "$LOG"
    fi
else
    echo "✗ ragflow-server not healthy after timeout (~5m); seed skipped. Check: docker logs ragflow-server" | tee -a "$LOG"
    docker logs --tail 30 ragflow-server >>"$LOG" 2>&1
fi

echo "✓ KnovaQ started${PROJECT:+ for project: $PROJECT}" | tee -a "$LOG"

# ── Post-start verification ──────────────────────────────────────────────────
echo "Running post-deploy verification..." | tee -a "$LOG"
if bash "$SCRIPT_DIR/verify.sh"; then
    echo "✓ Verification passed." | tee -a "$LOG"
else
    echo "✗ Verification reported FAILURES — inspect docker/logs/verify-*.log" | tee -a "$LOG"
fi
