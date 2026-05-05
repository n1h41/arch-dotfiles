#!/bin/bash

sketchybar --add item clock right \
  --set clock \
    icon="􀐫" \
    update_freq=30 \
    script="$PLUGIN_DIR/clock.sh" \
    click_script="sketchybar --trigger mouse.clicked NAME=clock"

sketchybar --add item battery right \
  --set battery \
    icon="􀛨" \
    update_freq=120 \
    script="$PLUGIN_DIR/battery.sh"

sketchybar --add item wifi right \
  --set wifi \
    icon="􀙇" \
    update_freq=5 \
    script="$PLUGIN_DIR/wifi.sh"

sketchybar --add item volume right \
  --set volume \
    icon="􀊧" \
    update_freq=0 \
    script="$PLUGIN_DIR/volume.sh" \
  --subscribe volume volume_change

sketchybar --add item cpu right \
  --set cpu \
    icon="􀧓" \
    update_freq=5 \
    script="$PLUGIN_DIR/cpu.sh"

NAME=clock "$PLUGIN_DIR/clock.sh"
NAME=battery "$PLUGIN_DIR/battery.sh"
NAME=wifi "$PLUGIN_DIR/wifi.sh"
NAME=volume "$PLUGIN_DIR/volume.sh"
NAME=cpu "$PLUGIN_DIR/cpu.sh"
