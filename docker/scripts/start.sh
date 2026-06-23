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

"${DC[@]}" up -d

# ── Post-start: seed ragflow auth ────────────────────────────────────────────
# rag_flow.{user,tenant,api_token,tenant_llm} tables are created by ragflow-server
# on its first boot (peewee), NOT during mysql initdb. So this seed must run AFTER
# ragflow-server is healthy — it cannot live in /docker-entrypoint-initdb.d.
# Idempotent (ON DUPLICATE KEY UPDATE), safe to re-run on every start.
SEED_FILE="/docker-entrypoint-initdb.d/post-seed/seed-ragflow-user.sql"
echo "Waiting for ragflow-server to become healthy (then seed ragflow auth)..."
st=starting
for _ in $(seq 1 60); do
    st=$(docker inspect -f '{{.State.Health.Status}}' ragflow-server 2>/dev/null || echo starting)
    [ "$st" = "healthy" ] && break
    sleep 5
done
if [ "$st" = "healthy" ]; then
    if docker exec ragflow-mysql sh -c "mysql -uroot -p'${MYSQL_PASSWORD}' < $SEED_FILE" 2>/dev/null; then
        echo "✓ ragflow auth seeded (user / tenant / api_token / local embedding)"
    else
        echo "⚠ ragflow seed failed — run manually: docker exec ragflow-mysql sh -c \"mysql -uroot -p\$MYSQL_PASSWORD < $SEED_FILE\""
    fi
else
    echo "⚠ ragflow-server not healthy after timeout; seed skipped. Re-run start.sh or seed manually."
fi

echo "✓ KnovaQ started${PROJECT:+ for project: $PROJECT}"
