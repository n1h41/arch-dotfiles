#!/bin/bash

sketchybar --add item front_app center \
  --set front_app \
    icon="􀤆" \
    icon.font="SF Pro:Bold:14.0" \
    label="Desktop" \
    label.font="SF Pro:Semibold:13.0" \
    background.drawing=on \
    background.color="$SURFACE" \
    background.corner_radius=8 \
    background.height=26 \
    padding_left=8 \
    padding_right=8 \
    script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched

NAME=front_app "$PLUGIN_DIR/front_app.sh"
