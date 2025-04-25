#!/bin/bash

# Path to the hyprland configuration file
FILE="/home/n1h41/dotfiles/.config/hypr/userprefs.conf"

# Check if file exists
if [ ! -f "$FILE" ]; then
    echo "Error: Configuration file not found at $FILE"
    exit 1
fi

# Find the line with eDP-1 monitor configuration (non-commented line)
LINE_NUM=$(grep -n "monitor = eDP-1" "$FILE" | grep -v "^#" | cut -d: -f1 | head -n 1)

if [ -z "$LINE_NUM" ]; then
    echo "Error: Could not find monitor configuration for eDP-1"
    exit 1
fi

# Get the current configuration
CURRENT_LINE=$(sed -n "${LINE_NUM}p" "$FILE")

# Toggle between enabled and disabled states
if [[ "$CURRENT_LINE" == *"disable"* ]]; then
    # Enable the monitor
    sed -i "${LINE_NUM}s/disable/2560x1600@60, auto, 2/" "$FILE"
    echo "Monitor eDP-1 has been enabled"
else
    # Disable the monitor
    sed -i "${LINE_NUM}s/2560.*/disable/" "$FILE"
    echo "Monitor eDP-1 has been disabled"
fi

notify-send "Monitor state changed" "The monitor eDP-1 has been $(echo "$CURRENT_LINE" | grep -oP '(?<=monitor = ).*')" -i ~/Downloads/nihal-abdulla.jpg

# Restart Hyprland to apply changes (uncomment if needed)
# hyprctl reload
