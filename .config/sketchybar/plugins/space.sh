#!/bin/bash

source "$CONFIG_DIR/colors.sh" 2>/dev/null || source "$HOME/.config/sketchybar/colors.sh"

if [ -z "$NAME" ]; then
  exit 0
fi

TARGET_WORKSPACE="${NAME#space.}"
FOCUSED_WORKSPACE="${AEROSPACE_FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$TARGET_WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color="$ACCENT_1" \
    icon.color="$BG" \
    label.drawing=off
  exit 0
fi

if aerospace list-windows --workspace "$TARGET_WORKSPACE" --count >/dev/null 2>&1; then
  WINDOW_COUNT=$(aerospace list-windows --workspace "$TARGET_WORKSPACE" --count 2>/dev/null)
else
  WINDOW_COUNT=0
fi

if [ "${WINDOW_COUNT:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color=0x66394b70 \
    icon.color="$ACCENT_2" \
    label.drawing=off
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color="$INACTIVE" \
    label.color="$INACTIVE" \
    label.drawing=off
fi
