#!/bin/bash

CPU_PCT=$(top -l 1 | awk '/CPU usage/ {gsub("%", "", $3); gsub("%", "", $5); print int($3 + $5)}')

if [ -z "$CPU_PCT" ]; then
  CPU_PCT="--"
fi

sketchybar --set "$NAME" icon="􀧓" label="${CPU_PCT}%"
