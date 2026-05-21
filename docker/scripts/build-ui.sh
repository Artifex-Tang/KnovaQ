#!/usr/bin/env bash
set -euo pipefail

PROJECT="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$DOCKER_DIR")"
UI_DIR="$REPO_ROOT/../gaisoft-ui"

DIST_SRC="$UI_DIR/dist"
HTML_DST="$DOCKER_DIR/gaisoft/nginx/html"

if [ ! -d "$DIST_SRC" ]; then
    echo "Error: dist not found at $DIST_SRC"
    echo "Build first: cd $UI_DIR && npm run build:prod"
    exit 1
fi

find "$HTML_DST" -mindepth 1 -not -name '.gitkeep' -delete
cp -r "$DIST_SRC"/. "$HTML_DST/"
echo "✓ html updated from dist"

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

"${DC[@]}" exec gaisoft-frontend nginx -s reload
echo "✓ nginx reloaded"
