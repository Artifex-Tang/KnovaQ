#!/usr/bin/env bash
set -euo pipefail

PROJECT="${1:-demo}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$DOCKER_DIR")"         # KnovaQ/
UI_DIR="$REPO_ROOT/../gaisoft-ui"            # sibling: E:/ccode/gaisoft-ui

DIST_SRC="$UI_DIR/dist"
HTML_DST="$DOCKER_DIR/gaisoft/nginx/html"

if [ ! -d "$DIST_SRC" ]; then
    echo "Error: dist not found at $DIST_SRC"
    echo "Build first: cd $UI_DIR && npm run build:prod"
    exit 1
fi

# Replace html directory contents
find "$HTML_DST" -mindepth 1 -not -name '.gitkeep' -delete
cp -r "$DIST_SRC"/. "$HTML_DST/"
echo "✓ html updated from dist"

# Reload nginx (no full restart needed)
cd "$DOCKER_DIR"
docker compose \
  --env-file "$DOCKER_DIR/.env" \
  --env-file "projects/$PROJECT/.env" \
  exec gaisoft-frontend nginx -s reload
echo "✓ nginx reloaded"
