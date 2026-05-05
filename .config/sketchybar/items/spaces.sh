#!/bin/bash

spaces=(1 2 3 4 5 6 7 8 9 10 S)

for space in "${spaces[@]}"; do
  sketchybar --add item "space.$space" left \
    --set "space.$space" \
      icon="$space" \
      label="$space" \
      label.drawing=off \
      icon.font="SF Pro:Bold:12.0" \
      icon.padding_left=8 \
      icon.padding_right=8 \
      label.font="SF Pro:Bold:10.0" \
      background.drawing=off \
      background.height=24 \
      background.corner_radius=8 \
      padding_left=2 \
      padding_right=2 \
      click_script="aerospace workspace $space" \
      script="$PLUGIN_DIR/space.sh" \
    --subscribe "space.$space" aerospace_workspace_change
done

for space in "${spaces[@]}"; do
  NAME="space.$space" "$PLUGIN_DIR/space.sh"
done
