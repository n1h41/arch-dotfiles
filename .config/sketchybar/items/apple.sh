#!/bin/bash

sketchybar --add item apple left \
  --set apple \
    icon="􀣺" \
    icon.font="SF Pro:Black:17.0" \
    label.drawing=off \
    padding_left=8 \
    padding_right=8 \
    click_script="open -a Raycast || osascript -e 'tell application \"System Events\" to key code 49 using {command down}'"
