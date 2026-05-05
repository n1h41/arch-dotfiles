#!/bin/bash

set -euo pipefail

MODE="${1:-s}"
OUT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUT_FILE="$OUT_DIR/${TIMESTAMP}.png"

mkdir -p "$OUT_DIR"

notify_saved() {
  local path="$1"
  osascript -e "display notification \"Saved to ${path}\" with title \"Screenshot\""
}

case "$MODE" in
  s)
    screencapture -ic
    ;;
  sf)
    screencapture -i "$OUT_FILE"
    notify_saved "$OUT_FILE"
    ;;
  m)
    screencapture -m "$OUT_FILE"
    notify_saved "$OUT_FILE"
    ;;
  p)
    screencapture "$OUT_FILE"
    notify_saved "$OUT_FILE"
    ;;
  *)
    echo "Usage: $0 {s|sf|m|p}" >&2
    exit 1
    ;;
esac
