#!/bin/bash

PERCENTAGE=$(pmset -g batt | grep -Eo '[0-9]+%' | tr -d '%' | head -n 1)
STATE_LINE=$(pmset -g batt | head -n 2 | tail -n 1)

if [ -z "$PERCENTAGE" ]; then
  sketchybar --set "$NAME" icon="􀛪" label="--%"
  exit 0
fi

if printf '%s' "$STATE_LINE" | grep -qi 'charging'; then
  ICON="􀢋"
elif [ "$PERCENTAGE" -ge 90 ]; then
  ICON="􀛨"
elif [ "$PERCENTAGE" -ge 60 ]; then
  ICON="􀺸"
elif [ "$PERCENTAGE" -ge 30 ]; then
  ICON="􀺶"
else
  ICON="􀛩"
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
