#!/bin/bash

source "$CONFIG_DIR/colors.sh" 2>/dev/null || source "$HOME/.config/sketchybar/colors.sh"

TIME_STR=$(date '+%H:%M')
DATE_STR=$(date '+%a %d %b %Y')

sketchybar --set "$NAME" label="$TIME_STR" \
  popup.drawing=off \
  popup.align=right \
  popup.height=26 \
  popup.background.color="$SURFACE" \
  popup.background.corner_radius=8 \
  popup.background.padding_left=8 \
  popup.background.padding_right=8

if [ "$SENDER" = "mouse.clicked" ]; then
  sketchybar --set "$NAME" popup.drawing=toggle
  sketchybar --add item "$NAME.date" popup."$NAME" \
    --set "$NAME.date" \
      label="$DATE_STR" \
      icon.drawing=off \
      background.drawing=off \
      label.color="$FG" \
      label.font="SF Pro:Semibold:12"
fi
