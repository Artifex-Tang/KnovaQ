#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
IMAGES_DIR="$DOCKER_DIR/images"

if [ ! -d "$IMAGES_DIR" ] || [ -z "$(ls "$IMAGES_DIR"/*.tar 2>/dev/null)" ]; then
    echo "Error: no .tar files found in $IMAGES_DIR"
    echo "Copy offline image tarballs to docker/images/ first"
    exit 1
fi

for TAR in "$IMAGES_DIR"/*.tar; do
    echo "Loading $(basename "$TAR") ..."
    docker load -i "$TAR"
done

echo ""
echo "✓ All images loaded"
echo "Now run: ./scripts/start.sh <project>"
