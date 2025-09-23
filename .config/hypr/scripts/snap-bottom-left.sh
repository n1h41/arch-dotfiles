#!/usr/bin/env bash
# Snap floating window

# Get monitor resolution (first monitor)
read MON_W MON_H <<< $(hyprctl monitors -j | jq -r '.[0].width, .[0].height' | tr '\n' ' ')
# Get active window dimensions
read WIN_W WIN_H <<< $(hyprctl activewindow -j | jq -r '.size[0], .size[1]' | tr '\n' ' ')

echo "Monitor size: ${MON_W}x${MON_H}"
echo "Window size: ${WIN_W}x${WIN_H}"
echo "Moving window to ($((MON_W - WIN_W)), $((MON_H - WIN_H)))"

# Snap to bottom-left
# hyprctl dispatch moveactive $((MON_W - WIN_W)) $((MON_H - WIN_H))
#
# at: 839,565
# size: 750,422
#
# at: 53,77
# size: 1493,871
