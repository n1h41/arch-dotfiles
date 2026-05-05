#!/bin/bash

APP_NAME="${APP:-$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)}"

if [ -z "$APP_NAME" ]; then
  APP_NAME="Desktop"
fi

ICON="􀤆"
case "$APP_NAME" in
  "Safari") ICON="􀎭" ;;
  "Google Chrome"|"Chromium") ICON="􀎫" ;;
  "Firefox") ICON="󰈹" ;;
  "WezTerm"|"Terminal"|"iTerm2") ICON="􀪏" ;;
  "Finder") ICON="􀈕" ;;
  "Code"|"Visual Studio Code") ICON="󰨞" ;;
  "Spotify") ICON="󰓇" ;;
  "Discord") ICON="󰙯" ;;
  "Slack") ICON="󰒱" ;;
esac

sketchybar --set "$NAME" icon="$ICON" label="$APP_NAME"
