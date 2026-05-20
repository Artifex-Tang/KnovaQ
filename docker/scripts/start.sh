#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"

PROJECT="${1:-}"
cd "$DOCKER_DIR"

if [ -n "$PROJECT" ]; then
    PROJECT_DIR="$DOCKER_DIR/projects/$PROJECT"
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "Error: project '$PROJECT' not found at $PROJECT_DIR"
        exit 1
    fi
    cp "$PROJECT_DIR/nginx/default.conf" "$DOCKER_DIR/gaisoft/nginx/conf.d/default.conf"
    echo "✓ nginx config copied from projects/$PROJECT/"
    docker compose --env-file "$DOCKER_DIR/.env" --env-file "$PROJECT_DIR/.env" up -d
    echo "✓ KnovaQ started for project: $PROJECT"
else
    if [ -f "$DOCKER_DIR/nginx/default.conf" ]; then
        cp "$DOCKER_DIR/nginx/default.conf" "$DOCKER_DIR/gaisoft/nginx/conf.d/default.conf"
        echo "✓ nginx config copied from docker/nginx/default.conf"
    fi
    docker compose --env-file "$DOCKER_DIR/.env" up -d
    echo "✓ KnovaQ started"
fi
