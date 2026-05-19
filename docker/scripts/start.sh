#!/usr/bin/env bash
set -euo pipefail

PROJECT="${1:-}"
if [ -z "$PROJECT" ]; then
    echo "Usage: $0 <project>"
    echo "Available projects:"
    ls "$(dirname "$0")/../projects/" | grep -v '^_'
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="$DOCKER_DIR/projects/$PROJECT"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: project '$PROJECT' not found at $PROJECT_DIR"
    exit 1
fi

# Copy this customer's nginx config into the runtime directory
cp "$PROJECT_DIR/nginx/default.conf" \
   "$DOCKER_DIR/gaisoft/nginx/conf.d/default.conf"
echo "✓ nginx config copied from projects/$PROJECT/"

# Launch compose with this customer's env overrides
cd "$DOCKER_DIR"
docker compose --env-file "$PROJECT_DIR/.env" up -d

echo "✓ KnovaQ started for project: $PROJECT"
