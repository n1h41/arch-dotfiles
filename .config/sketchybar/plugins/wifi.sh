#!/bin/bash

WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2; exit}')

if [ -z "$WIFI_DEVICE" ]; then
  sketchybar --set "$NAME" icon="􀙈" label="No Wi-Fi"
  exit 0
fi

SSID=$(ipconfig getsummary "$WIFI_DEVICE" 2>/dev/null | awk -F ' SSID : ' '/ SSID : /{print $2}' | head -n 1)

if [ -n "$SSID" ]; then
  sketchybar --set "$NAME" icon="􀙇" label.drawing=off
else
  sketchybar --set "$NAME" icon="􀙈" label.drawing=off
fi
