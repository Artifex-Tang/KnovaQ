#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT="${1:-}"

cd "$DOCKER_DIR"

# Source env files into shell; docker compose inherits from environment.
# Avoids --env-file which requires Docker Compose >= v2.2.
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

docker compose up -d
echo "✓ KnovaQ started${PROJECT:+ for project: $PROJECT}"
