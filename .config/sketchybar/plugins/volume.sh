#!/bin/bash

if [ "$SENDER" = "volume_change" ] && [ -n "$INFO" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
fi

if [ -z "$VOLUME" ]; then
  VOLUME=0
fi

if [ "$VOLUME" -eq 0 ]; then
  ICON="􀊣"
elif [ "$VOLUME" -le 30 ]; then
  ICON="􀊥"
elif [ "$VOLUME" -le 70 ]; then
  ICON="􀊧"
else
  ICON="􀊩"
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
