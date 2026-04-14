#!/bin/bash

# See ~/.dockerfiles/README.md for details

IMAGE="dev"

# Build image if it doesn't exist
if ! podman image exists "$IMAGE"; then
  echo "Image '$IMAGE' not found, building..."
  podman build --tag "$IMAGE" --file "$HOME/.dockerfiles/Dockerfile.$IMAGE" "$HOME/.dockerfiles/"
else
  echo "Image '$IMAGE' found"
fi

# Configuration
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")
VOLUME_NAME="$PROJECT_NAME-sandbox"
SECRETS_FILE="$HOME/.secrets/$PROJECT_NAME.env"
NETWORK="${SANDBOX_NETWORK:-none}"

BASE_ARGS=(
  --interactive --tty --rm
  --network "$NETWORK"
  --security-opt no-new-privileges
  --cap-drop ALL
  --volume "$PROJECT_DIR":/"$VOLUME_NAME":Z
  --workdir /"$VOLUME_NAME"
)

# Run container
if [ -f "$SECRETS_FILE" ]; then
  podman run "${BASE_ARGS[@]}" --env-file "$SECRETS_FILE" "$IMAGE" bash
else
  echo "No secrets file found at $SECRETS_FILE, skipping..."
  podman run "${BASE_ARGS[@]}" "$IMAGE" bash
fi
