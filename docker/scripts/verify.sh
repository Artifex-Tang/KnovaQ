#!/usr/bin/env bash
# ============================================================================
# KnovaQ post-deployment verification.
# Runs a series of health checks against a running stack and writes a
# timestamped log to docker/logs/. Exit 0 = all pass, non-zero = failures.
# Safe to run standalone any time:  bash docker/scripts/verify.sh
# Called automatically at the end of start.sh.
# ============================================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
cd "$DOCKER_DIR"

# Load env (ports, passwords, api key) if present
if [ -f "$DOCKER_DIR/.env" ]; then set -a; . "$DOCKER_DIR/.env"; set +a; fi

mkdir -p "$DOCKER_DIR/logs"
LOG="$DOCKER_DIR/logs/verify-$(date +%Y%m%d-%H%M%S).log"

MYSQL_PW="${MYSQL_PASSWORD:-infini_rag_flow}"
HTTP_RAGFLOW="${RAGFLOW_HTTP_PORT:-8070}"
HTTP_API="${GAISOFT_SERVER_PORT:-8088}"
HTTP_FRONT="${GAISOFT_FRONTEND_PORT:-8899}"
TENANT="a0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5"

PASS=0; FAIL=0
log()  { echo "$*" | tee -a "$LOG"; }
ok()   { log "  [PASS] $*"; PASS=$((PASS+1)); }
bad()  { log "  [FAIL] $*"; FAIL=$((FAIL+1)); }
# run a query against ragflow-mysql; stderr (incl. password warning) -> log only
mysql_q() { docker exec ragflow-mysql mysql -uroot -p"$MYSQL_PW" -N -e "$1" 2>>"$LOG"; }

log "================ KnovaQ verify  $(date '+%F %T') ================"

# 1. Containers running / healthy ------------------------------------------------
log "[1/8] containers"
for c in ragflow-server ragflow-mysql ragflow-redis ragflow-es-01 ragflow-minio equipment-server equipment-front; do
    state=$(docker inspect -f '{{.State.Status}}' "$c" 2>/dev/null || echo missing)
    health=$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}-{{end}}' "$c" 2>/dev/null || echo -)
    if [ "$state" = "running" ]; then
        ok "$c running (health=$health)"
    else
        bad "$c state=$state — dumping last 25 log lines"
        { echo "----- docker logs $c -----"; docker logs --tail 25 "$c" 2>&1; } >>"$LOG"
    fi
done

# 2. equipment_iqas schema (gaisoft) ---------------------------------------------
log "[2/8] equipment_iqas schema"
n=$(mysql_q "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='equipment_iqas';")
if [ "${n:-0}" -ge 40 ] 2>/dev/null; then ok "equipment_iqas tables=$n"
else bad "equipment_iqas tables=${n:-0} (expected >=40) — equipment_iqas.sql init may have failed; check mysql initdb log"; fi

# 3. ragflow user seeded ---------------------------------------------------------
log "[3/8] ragflow user (post-seed)"
u=$(mysql_q "SELECT COUNT(*) FROM rag_flow.user WHERE email='admin@163.com';")
if [ "${u:-0}" -ge 1 ] 2>/dev/null; then ok "ragflow user admin@163.com present"
else bad "ragflow user MISSING — start.sh post-seed did not run (ragflow not healthy in time?) or rag_flow tables absent"; fi

# 4. api_token matches gaisoft RagFlowKey ----------------------------------------
log "[4/8] api_token vs sys_config.RagFlowKey"
cfg_key=$(mysql_q "SELECT config_value FROM equipment_iqas.sys_config WHERE config_key='RagFlowKey';")
tok=$(mysql_q "SELECT COUNT(*) FROM rag_flow.api_token WHERE token='${cfg_key}';")
if [ "${tok:-0}" -ge 1 ] 2>/dev/null; then ok "api_token registered for RagFlowKey"
else bad "no api_token for key '${cfg_key}' — /api/v1 calls will return code:109"; fi

# 5. ragflow API key live check --------------------------------------------------
log "[5/8] ragflow API key live check (/api/v1/datasets)"
resp=$(docker exec ragflow-server sh -c "curl -s -m 10 http://localhost:9380/api/v1/datasets -H 'Authorization: Bearer ${cfg_key}'" 2>>"$LOG")
echo "  response: $resp" >>"$LOG"
case "$resp" in
    *'"code":0'*) ok "API key valid (code:0)";;
    *109*)        bad "API key INVALID (code:109) — api_token mismatch. resp=${resp:0:120}";;
    '')           bad "API key check: empty response (ragflow-server down?)";;
    *)            bad "API key check unexpected: ${resp:0:120}";;
esac

# 6. tenant default embedding ----------------------------------------------------
log "[6/8] tenant default embedding"
embd=$(mysql_q "SELECT embd_id FROM rag_flow.tenant WHERE id='${TENANT}';")
inllm=$(mysql_q "SELECT COUNT(*) FROM rag_flow.tenant_llm WHERE tenant_id='${TENANT}' AND model_type='embedding';")
if [ -n "$embd" ] && [ "${inllm:-0}" -ge 1 ] 2>/dev/null; then ok "embd_id=$embd, embedding models in tenant_llm=$inllm"
else bad "default embedding not set (embd_id='${embd}', tenant_llm embeddings=${inllm:-0})"; fi

# 7. HTTP endpoints --------------------------------------------------------------
log "[7/8] HTTP endpoints (localhost)"
for pair in "ragflow:${HTTP_RAGFLOW}" "gaisoft-api:${HTTP_API}" "gaisoft-front:${HTTP_FRONT}"; do
    name=${pair%%:*}; port=${pair##*:}
    code=$(curl -s -o /dev/null -m 10 -w '%{http_code}' "http://localhost:${port}/" 2>>"$LOG")
    if [ "$code" = "200" ]; then ok "$name :$port -> 200"
    else bad "$name :$port -> ${code:-000} (expected 200)"; fi
done

# 8. gaisoft -> ragflow auth errors in recent logs -------------------------------
log "[8/8] gaisoft->ragflow auth errors (last 2m)"
errs=$(docker logs --since 2m equipment-server 2>&1 | grep -ciE '401: Unauthorized|API key is invalid' || true)
if [ "${errs:-0}" -eq 0 ] 2>/dev/null; then ok "no ragflow auth errors in last 2m"
else bad "$errs ragflow auth error(s) in last 2m — see: docker logs equipment-server | grep -iE '401|invalid'"; fi

log "================ result: PASS=$PASS  FAIL=$FAIL ================"
log "full log: $LOG"
if [ "$FAIL" -eq 0 ]; then log "RESULT: ✓ ALL CHECKS PASSED"; exit 0
else log "RESULT: ✗ ${FAIL} CHECK(S) FAILED — inspect $LOG"; exit 1; fi
