#!/bin/bash

set -euo pipefail

APP_NAME="WezTerm"
WINDOW_TITLE="scratchpad"

running_windows_count() {
  osascript <<'APPLESCRIPT'
tell application "System Events"
  if exists application process "WezTerm" then
    tell application process "WezTerm"
      set matchingWindows to (every window whose name contains "scratchpad")
      return count of matchingWindows
    end tell
  else
    return 0
  end if
end tell
APPLESCRIPT
}

frontmost_is_scratchpad() {
  osascript <<'APPLESCRIPT'
tell application "System Events"
  if exists application process "WezTerm" then
    tell application process "WezTerm"
      if (count of windows) is 0 then
        return "false"
      end if
      try
        if (name of front window) contains "scratchpad" then
          return "true"
        end if
      end try
    end tell
  end if
end tell
return "false"
APPLESCRIPT
}

hide_scratchpad() {
  osascript <<'APPLESCRIPT'
tell application "System Events"
  if exists application process "WezTerm" then
    tell application process "WezTerm"
      repeat with w in (every window whose name contains "scratchpad")
        try
          set value of attribute "AXMinimized" of w to true
        end try
      end repeat
    end tell
  end if
end tell
APPLESCRIPT
}

show_scratchpad() {
  osascript <<'APPLESCRIPT'
tell application "WezTerm" to activate
tell application "System Events"
  if exists application process "WezTerm" then
    tell application process "WezTerm"
      repeat with w in (every window whose name contains "scratchpad")
        try
          set value of attribute "AXMinimized" of w to false
        end try
        try
          perform action "AXRaise" of w
        end try
      end repeat
    end tell
  end if
end tell
APPLESCRIPT
}

launch_scratchpad() {
  open -na "$APP_NAME" --args start --always-new-process --cwd "$HOME" -- bash -lc "printf '\\033]0;%s\\007' '$WINDOW_TITLE'; exec \$SHELL"
}

count="$(running_windows_count | tr -d '[:space:]')"

if [[ "$count" == "0" ]]; then
  launch_scratchpad
  exit 0
fi

if [[ "$(frontmost_is_scratchpad | tr -d '[:space:]')" == "true" ]]; then
  hide_scratchpad
else
  show_scratchpad
fi
