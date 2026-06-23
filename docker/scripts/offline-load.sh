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
echo "Verifying expected image repositories are present..."
MISSING=0
for IMG in infiniflow/ragflow elasticsearch mysql minio/minio valkey/valkey gaisoftmes nginx; do
    if docker images --format '{{.Repository}}' | grep -qx "$IMG" || \
       docker images --format '{{.Repository}}' | grep -q "$IMG"; then
        echo "  [OK]      $IMG"
    else
        echo "  [MISSING] $IMG"
        MISSING=$((MISSING+1))
    fi
done

if [ "$MISSING" -ne 0 ]; then
    echo "✗ $MISSING expected image(s) missing — check that all *.tar files are present and re-run."
    exit 1
fi

echo "✓ All images loaded and verified"
echo "Now run: ./scripts/start.sh <project>"
