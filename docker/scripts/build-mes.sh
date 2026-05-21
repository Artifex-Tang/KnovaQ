#!/usr/bin/env bash
set -euo pipefail

PROJECT="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$DOCKER_DIR")"
MES_DIR="$REPO_ROOT/../gaisoft-mes"

JAR_SRC="$MES_DIR/gaisoft-admin/target/gaisoftmes.jar"
JAR_DST="$DOCKER_DIR/gaisoft/jar/gaisoftmes.jar"

if [ ! -f "$JAR_SRC" ]; then
    echo "Error: jar not found at $JAR_SRC"
    echo "Build first: cd $MES_DIR && mvn clean package -pl gaisoft-admin -am -DskipTests"
    exit 1
fi

cp "$JAR_SRC" "$JAR_DST"
echo "✓ Copied gaisoftmes.jar"

cd "$DOCKER_DIR"

if docker compose version >/dev/null 2>&1; then
    DC=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
    DC=(docker-compose)
else
    echo "Error: docker compose plugin or docker-compose not found"
    exit 1
fi

set -a
. "$DOCKER_DIR/.env"
[ -n "$PROJECT" ] && . "$DOCKER_DIR/projects/$PROJECT/.env"
set +a

"${DC[@]}" restart gaisoft-server
echo "✓ gaisoft-server restarted"
