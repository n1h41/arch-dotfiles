#!/bin/bash

# Path to the file
file="/home/n1h41/dotfiles/.config/hypr/userprefs.conf"

# Get the current line
current_line=$(sed -n '13p' "$file")

if [[ "$current_line" == *"auto, 2"* ]]; then
  sed -i '13s/auto, 2/auto, auto/' "$file"
  # sed -i '13s/auto, 2/auto, 1.33333/' "$file"
else
  sed -i '13s/auto, auto/auto, 2/' "$file"
fi

notify-send "Monitor scale changed" "The monitor scale has been changed to $(sed -n '13p' "$file")" -i ~/Downloads/nihal-abdulla.jpg
