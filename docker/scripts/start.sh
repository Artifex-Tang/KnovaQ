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
echo "✓ KnovaQ started${PROJECT:+ for project: $PROJECT}"

# Auto-sync ragflow auth after containers are up
echo ""
echo "Syncing ragflow authentication..."
bash "$SCRIPT_DIR/sync-ragflow-auth.sh" && echo "✓ ragflow auth synced" || echo "⚠ ragflow auth sync failed (non-fatal)"
