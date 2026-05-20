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
if [ -n "$PROJECT" ]; then
    docker compose --env-file "$DOCKER_DIR/.env" --env-file "projects/$PROJECT/.env" restart gaisoft-server
else
    docker compose --env-file "$DOCKER_DIR/.env" restart gaisoft-server
fi
echo "✓ gaisoft-server restarted"
