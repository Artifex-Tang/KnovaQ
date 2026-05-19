#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"
IMAGES_DIR="$DOCKER_DIR/images"

mkdir -p "$IMAGES_DIR"

cd "$DOCKER_DIR"

# Get full list of images from compose (includes all service images)
IMAGES=$(docker compose config --images 2>/dev/null)

if [ -z "$IMAGES" ]; then
    echo "Error: could not read images from docker-compose.yml"
    exit 1
fi

for IMAGE in $IMAGES; do
    # Convert image name to safe filename: replace / and : with _
    FILENAME="${IMAGE//\//_}"
    FILENAME="${FILENAME//:/_}.tar"
    echo "Saving $IMAGE → images/$FILENAME"
    docker save "$IMAGE" -o "$IMAGES_DIR/$FILENAME"
done

echo ""
echo "✓ All images saved to docker/images/"
echo "  Total size: $(du -sh "$IMAGES_DIR" | cut -f1)"
echo ""
echo "Next: tar -czf knovaq-offline.tar.gz docker/ (then copy to customer machine)"
