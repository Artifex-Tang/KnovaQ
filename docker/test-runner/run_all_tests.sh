#!/usr/bin/env bash
# Run every test suite SERIALLY against the running stack, emit one JUnit XML
# per suite, drain the parse backlog after heavy suites, then build the report.
#
# WHY serial + drain: every suite shares the one ragflow task_executor + ES +
# MinIO + Redis. Running suites concurrently (or back-to-back after a load
# suite) lets one suite's parse backlog starve the next, and a drain-restart in
# one run kills another's connections. So: one at a time, drain after the heavy
# ones (G load, H parser-coverage).
#
# Usage (on the deploy host, from docker/):
#   RAGFLOW_API_KEY=$(grep RAGFLOW_API_KEY .env | cut -d= -f2) \
#     bash test-runner/run_all_tests.sh
# Env:
#   NET=knovaq_ragflow  TEST_IMAGE=knovaq-test-runner:latest
#   G_MAX_DOCS_PER_TOPIC=15  H_DOCS_PER_PARSER=10   (override to scale/stress)
set -u
NET="${NET:-knovaq_ragflow}"
IMG="${TEST_IMAGE:-knovaq-test-runner:latest}"
HERE="$(cd "$(dirname "$0")" && pwd)"
REPORTS="$HERE/reports"
mkdir -p "$REPORTS"
rm -f "$REPORTS"/*.xml

run() {  # run <suite_key> <test_file>
  echo "########## $1  ($(date +%H:%M:%S)) ##########"
  docker run --rm --network "$NET" \
    -v "$HERE/tests:/tests/tests" -v "$REPORTS:/tests/reports" \
    -e RAGFLOW_BASE_URL="${RAGFLOW_BASE_URL:-http://ragflow:9380}" \
    -e RAGFLOW_API_KEY="${RAGFLOW_API_KEY:-}" \
    -e GAISOFT_API_URL="${GAISOFT_API_URL:-http://gaisoft-server:8080}" \
    -e GAISOFT_FRONTEND_URL="${GAISOFT_FRONTEND_URL:-http://gaisoft-frontend:80}" \
    -e GAISOFT_LOGIN_USER="${GAISOFT_LOGIN_USER:-admin}" \
    -e GAISOFT_LOGIN_PASS="${GAISOFT_LOGIN_PASS:-admin123}" \
    -e G_MAX_DOCS_PER_TOPIC="${G_MAX_DOCS_PER_TOPIC:-15}" \
    -e H_DOCS_PER_PARSER="${H_DOCS_PER_PARSER:-10}" \
    -e H_QA_QUESTIONS="${H_QA_QUESTIONS:-3}" \
    "$IMG" "tests/$2" "--junitxml=/tests/reports/$1.xml" 2>&1 | tail -5
}

drain() {  # clear parse backlog so the next suite starts on an idle executor
  echo "---- drain (flush queue + restart ragflow) ----"
  docker exec ragflow-redis sh -c "redis-cli -a ${REDIS_PASSWORD:-infini_rag_flow} -n 1 FLUSHDB >/dev/null 2>&1" 2>/dev/null
  docker restart ragflow-server >/dev/null 2>&1
  for i in $(seq 1 20); do
    [ "$(docker inspect ragflow-server --format '{{.State.Health.Status}}' 2>/dev/null)" = healthy ] && break
    sleep 6
  done
}

run suite_a test_suite_a_functional.py
run suite_b test_suite_b_issues.py
run suite_c test_suite_c_full_coverage.py
run suite_d test_suite_d_interactive.py
run suite_e test_suite_e_business_logic.py
run suite_f test_suite_f_bug_verify.py
run suite_g test_suite_g_kb_pipeline.py
drain
run suite_h test_suite_h_parser_coverage.py
drain

echo "########## building report ##########"
docker run --rm -v "$HERE:/tests" --entrypoint python3 "$IMG" /tests/gen_report.py /tests/reports
echo "Report: $REPORTS/TEST_REPORT.html  (+ .md)"
