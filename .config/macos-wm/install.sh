#!/bin/bash
# macOS Tiling WM Stack Installer
# Replicates Hyprland workflow using AeroSpace + SketchyBar + JankyBorders + skhd
#
# Usage: chmod +x install.sh && ./install.sh

set -euo pipefail

DOTFILES_CONFIG="$HOME/dotfiles/.config"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─── Preflight Checks ──────────────────────────────────────────────
info "Checking prerequisites..."

if ! command -v brew &>/dev/null; then
    error "Homebrew is not installed. Install it first: https://brew.sh"
fi
success "Homebrew found"

# ─── Install Core Components ───────────────────────────────────────
info "Installing tiling WM stack..."

# AeroSpace — tiling window manager (no SIP changes needed)
if ! brew list --cask nikitabobko/tap/aerospace &>/dev/null 2>&1; then
    info "Installing AeroSpace..."
    brew install --cask nikitabobko/tap/aerospace
else
    success "AeroSpace already installed"
fi

# SketchyBar — status bar (replaces Waybar/Polybar)
if ! brew list sketchybar &>/dev/null 2>&1; then
    info "Installing SketchyBar..."
    brew tap FelixKratz/formulae
    brew install sketchybar
else
    success "SketchyBar already installed"
fi

# JankyBorders — window borders (replaces Hyprland native borders)
if ! brew list borders &>/dev/null 2>&1; then
    info "Installing JankyBorders..."
    brew tap FelixKratz/formulae 2>/dev/null || true
    brew install borders
else
    success "JankyBorders already installed"
fi

# skhd — hotkey daemon (for non-WM keybinds: launchers, screenshots, media)
if ! brew list skhd &>/dev/null 2>&1; then
    info "Installing skhd..."
    brew install koekeishiya/formulae/skhd
else
    success "skhd already installed"
fi

# ─── Install Supporting Tools ──────────────────────────────────────
info "Installing supporting tools..."

# Fonts — Nerd Font for SketchyBar icons
if ! brew list --cask font-hack-nerd-font &>/dev/null 2>&1; then
    info "Installing Hack Nerd Font..."
    brew install --cask font-hack-nerd-font
else
    success "Hack Nerd Font already installed"
fi

# SF Symbols — Apple's icon font (for SketchyBar)
if ! brew list --cask sf-symbols &>/dev/null 2>&1; then
    info "Installing SF Symbols..."
    brew install --cask sf-symbols
else
    success "SF Symbols already installed"
fi

# jq — JSON processor (used by helper scripts)
if ! command -v jq &>/dev/null; then
    info "Installing jq..."
    brew install jq
else
    success "jq already installed"
fi

# nowplaying-cli — media info (replaces playerctl)
if ! command -v nowplaying-cli &>/dev/null; then
    info "Installing nowplaying-cli..."
    brew install nowplaying-cli
else
    success "nowplaying-cli already installed"
fi

# ─── Symlink Configs ──────────────────────────────────────────────
info "Setting up config symlinks..."

link_config() {
    local src="$DOTFILES_CONFIG/$1"
    local dst="$HOME/.config/$1"

    if [ ! -e "$src" ]; then
        warn "Source not found: $src — skipping"
        return
    fi

    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        warn "Backing up existing $dst to ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    success "Linked $1"
}

# AeroSpace config lives at ~/.aerospace.toml (not in .config)
if [ -f "$DOTFILES_CONFIG/aerospace/aerospace.toml" ]; then
    if [ -L "$HOME/.aerospace.toml" ]; then
        rm "$HOME/.aerospace.toml"
    elif [ -f "$HOME/.aerospace.toml" ]; then
        warn "Backing up existing ~/.aerospace.toml"
        mv "$HOME/.aerospace.toml" "$HOME/.aerospace.toml.bak"
    fi
    ln -sf "$DOTFILES_CONFIG/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
    success "Linked aerospace.toml → ~/.aerospace.toml"
fi

link_config "sketchybar"
link_config "borders"
link_config "skhd"

# ─── Set Permissions ──────────────────────────────────────────────
info "Setting executable permissions..."

chmod +x "$DOTFILES_CONFIG/sketchybar/sketchybarrc" 2>/dev/null || true
find "$DOTFILES_CONFIG/sketchybar/plugins" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find "$DOTFILES_CONFIG/sketchybar/items" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
chmod +x "$DOTFILES_CONFIG/borders/bordersrc" 2>/dev/null || true
find "$DOTFILES_CONFIG/skhd/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

success "Permissions set"

# ─── macOS System Settings Recommendations ─────────────────────────
echo ""
echo -e "${YELLOW}━━━ Required macOS Settings ━━━${NC}"
echo ""
echo "  1. System Settings → Desktop & Dock:"
echo "     - Disable 'Automatically rearrange Spaces based on most recent use'"
echo "     - Enable  'Displays have separate Spaces' (for multi-monitor)"
echo "     - Disable 'Stage Manager'"
echo "     - Set 'Automatically hide and show the Dock' → ON"
echo ""
echo "  2. System Settings → Desktop & Dock → Mission Control:"
echo "     - Disable 'Group windows by application'"
echo ""
echo "  3. System Settings → Accessibility → Display:"
echo "     - Enable  'Reduce motion' (removes macOS space-switch animation)"
echo ""
echo "  4. Create 10 Spaces in Mission Control:"
echo "     - Open Mission Control (F3 or Ctrl+Up)"
echo "     - Click '+' in top-right to create spaces until you have 10"
echo "     - AeroSpace uses virtual workspaces so this is optional but recommended"
echo ""
echo "  5. System Settings → Keyboard → Keyboard Shortcuts → Mission Control:"
echo "     - Disable all 'Switch to Desktop N' shortcuts (they conflict with AeroSpace)"
echo ""
echo "  6. Grant Accessibility permissions when prompted:"
echo "     - AeroSpace, skhd, SketchyBar, and borders will all request permission"
echo "     - System Settings → Privacy & Security → Accessibility → enable each"
echo ""

# ─── Start Services ───────────────────────────────────────────────
echo -e "${YELLOW}━━━ Starting Services ━━━${NC}"
echo ""

start_service() {
    local name="$1"
    local cmd="$2"

    info "Starting $name..."
    eval "$cmd" 2>/dev/null && success "$name started" || warn "$name may need manual start or accessibility permission"
}

start_service "skhd"        "brew services start skhd"
start_service "SketchyBar"  "brew services start sketchybar"
start_service "JankyBorders" "brew services start borders"

echo ""
info "AeroSpace should start at login automatically (configured in aerospace.toml)"
info "If not running, launch AeroSpace.app from /Applications"
echo ""

# ─── Summary ──────────────────────────────────────────────────────
echo -e "${GREEN}━━━ Installation Complete ━━━${NC}"
echo ""
echo "  Stack installed:"
echo "    AeroSpace    — Tiling WM (replaces Hyprland)"
echo "    SketchyBar   — Status bar (replaces Waybar)"
echo "    JankyBorders — Window borders (replaces Hyprland borders)"
echo "    skhd         — Hotkey daemon (app launchers, screenshots, etc.)"
echo ""
echo "  Config locations:"
echo "    ~/.aerospace.toml           → AeroSpace"
echo "    ~/.config/sketchybar/       → SketchyBar"
echo "    ~/.config/borders/bordersrc → JankyBorders"
echo "    ~/.config/skhd/skhdrc       → skhd"
echo ""
echo "  Keybind cheat sheet:"
echo "    alt + h/j/k/l       → Focus left/down/up/right"
echo "    alt + shift + hjkl  → Move window"
echo "    alt + 1-0           → Switch workspace 1-10"
echo "    alt + shift + 1-0   → Move window to workspace"
echo "    alt + w             → Toggle float"
echo "    alt + enter         → Toggle fullscreen"
echo "    alt + q             → Close window"
echo "    alt + s             → Scratchpad workspace"
echo "    alt + t             → Terminal"
echo "    alt + a             → App launcher (Raycast)"
echo "    alt + p             → Screenshot (snip)"
echo "    alt + shift + l     → Lock screen"
echo ""
echo -e "  ${YELLOW}Remember to grant Accessibility permissions to all tools!${NC}"
echo ""
