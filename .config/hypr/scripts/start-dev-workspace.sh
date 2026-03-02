#!/bin/bash

# Check if dev workspace apps are already running
if pgrep -f "dev-tmux" > /dev/null && pgrep -f "emulator.*flutter_emulator" > /dev/null; then
	# Already running? Switch to workspace 1
	hyprctl dispatch workspace 1
	notify-send "Dev Workspace" "Already running, switching to workspace 1"
fi

if ! pgrep -f "dev-tmux" > /dev/null; then
	hyprctl dispatch exec "[workspace 1 silent] kitty --title dev-tmux -e tmux new-session -A -s dev"
fi

if ! pgrep -f "emulator.*flutter_emulator" > /dev/null; then
	hyprctl dispatch exec "[workspace 1 silent] emulator -avd flutter_emulator"
fi

sleep 1
hyprctl dispatch workspace 1

notify-send "Dev workspace" "Starting development environment..."
