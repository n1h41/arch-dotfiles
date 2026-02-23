#!/usr/bin/env zsh

#! ██████╗░░█████╗░  ███╗░░██╗░█████╗░████████╗  ███████╗██████╗░██╗████████╗
#! ██╔══██╗██╔══██╗  ████╗░██║██╔══██╗╚══██╔══╝  ██╔════╝██╔══██╗██║╚══██╔══╝
#! ██║░░██║██║░░██║  ██╔██╗██║██║░░██║░░░██║░░░  █████╗░░██║░░██║██║░░░██║░░░
#! ██║░░██║██║░░██║  ██║╚████║██║░░██║░░░██║░░░  ██╔══╝░░██║░░██║██║░░░██║░░░
#! ██████╔╝╚█████╔╝  ██║░╚███║╚█████╔╝░░░██║░░░  ███████╗██████╔╝██║░░░██║░░░
#! ╚═════╝░░╚════╝░  ╚═╝░░╚══╝░╚════╝░░░░╚═╝░░░  ╚══════╝╚═════╝░╚═╝░░░╚═╝░░░

# Hyde's Shell Environment Initialization Script
# If users used UWSM, uwsm will override any variables set anywhere in your shell configurations

# Detect OS
case "$(uname -s)" in
    Darwin) IS_MACOS=1 ;;
    Linux)  IS_LINUX=1 ;;
esac

# Basic PATH prepending (user local bin)
PATH="$HOME/.local/bin:$PATH"

# XDG Base Directory Specification variables with defaults
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_DATA_DIRS="${XDG_DATA_DIRS:-$XDG_DATA_HOME:/usr/local/share:/usr/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# XDG User Directories
if [[ -n $IS_MACOS ]]; then
    # macOS: Use standard macOS directories
    XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-$HOME/Desktop}"
    XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
    XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-$HOME/Templates}"
    XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:-$HOME/Public}"
    XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-$HOME/Documents}"
    XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-$HOME/Music}"
    XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
    XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$HOME/Movies}"
elif command -v xdg-user-dir >/dev/null 2>&1; then
    # Linux: Use xdg-user-dir if available
    XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-$(xdg-user-dir DESKTOP)}"
    XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$(xdg-user-dir DOWNLOAD)}"
    XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-$(xdg-user-dir TEMPLATES)}"
    XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:-$(xdg-user-dir PUBLICSHARE)}"
    XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-$(xdg-user-dir DOCUMENTS)}"
    XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-$(xdg-user-dir MUSIC)}"
    XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$(xdg-user-dir PICTURES)}"
    XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$(xdg-user-dir VIDEOS)}"
fi

# Less history file location
LESSHISTFILE="${LESSHISTFILE:-/tmp/less-hist}"

# Application config files
PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
TERMINFO="$XDG_DATA_HOME"/terminfo
TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
WGETRC="${XDG_CONFIG_HOME}/wgetrc"
PYTHON_HISTORY="$XDG_STATE_HOME/python_history"

# HyDEs Compositor Configuration (Linux only)
if [[ -n $IS_LINUX ]]; then
    export HYPRLAND_CONFIG="${XDG_DATA_HOME:-$HOME/.local/share}/hypr/hyprland.conf"
fi

# Export all variables
export PATH \
  XDG_CONFIG_HOME XDG_DATA_HOME XDG_DATA_DIRS XDG_STATE_HOME XDG_CACHE_HOME \
  XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR XDG_TEMPLATES_DIR XDG_PUBLICSHARE_DIR \
  XDG_DOCUMENTS_DIR XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR \
  LESSHISTFILE PARALLEL_HOME SCREENRC TERMINFO TERMINFO_DIRS WGETRC PYTHON_HISTORY
