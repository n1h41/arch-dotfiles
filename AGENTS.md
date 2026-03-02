# AGENTS.md - Linux Dotfiles Configuration

This document provides guidance for AI coding agents working in this dotfiles repository.

## Repository Overview

Personal Linux dotfiles for a complete desktop environment including:
- **Window Managers**: i3-wm, Hyprland
- **Terminal**: WezTerm
- **Shell**: Zsh (oh-my-zsh)
- **Editor**: Neovim (see `.config/nvim/AGENTS.md` for Neovim-specific guidance)
- **Terminal Multiplexer**: tmux
- **Utilities**: rofi, polybar, picom, dunst, yazi, starship

## Directory Structure

```
dotfiles/
├── .config/
│   ├── nvim/              # Neovim (has own AGENTS.md)
│   ├── i3/                # i3 window manager
│   ├── hypr/              # Hyprland compositor
│   ├── wezterm/           # WezTerm terminal
│   ├── tmux/              # tmux configuration
│   ├── zsh/               # Zsh shell config
│   ├── rofi/              # Application launcher
│   ├── polybar/           # Status bar
│   ├── picom/             # Compositor
│   └── yazi/              # File manager
└── .gitignore
```

## Build/Lint/Test Commands

### No Traditional Build System

This is a dotfiles repository - there's no build pipeline. Changes take effect when:
- Config files are sourced/reloaded
- Applications are restarted
- Relevant daemons/services are reloaded

### Validation Per Component

```bash
# Neovim
nvim --headless -c 'checkhealth' -c 'qa'
luacheck .config/nvim/lua/ --globals vim

# Zsh
zsh -n .config/zsh/.zshrc  # Syntax check

# i3-wm
i3 -C -c .config/i3/config  # Validate config

# Hyprland
hyprctl reload  # Reload config (if running)

# tmux
tmux source .config/tmux/tmux.conf  # Reload config

# WezTerm
wezterm -c .config/wezterm/wezterm.lua --version  # Validate syntax
```

### Deployment

Typically deployed via symlinks or stow. No automated installer present.

## Code Style Guidelines

### Configuration File Types

| File Type | Style | Notes |
|-----------|-------|-------|
| **Lua** (nvim, wezterm) | Tabs (width=2), snake_case | See nvim/AGENTS.md for details |
| **Shell** (zsh) | Spaces (2), snake_case | Follow existing alias patterns |
| **i3/Hypr** | Spaces (4) | Follow WM-specific syntax |
| **tmux** | Spaces, prefix C-e | Vi mode keybindings |

### Lua Configuration (WezTerm, Neovim)

```lua
-- Indentation: TABS (not spaces), width 2
-- Module pattern
local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- Modular requires
local keys = require('config.keys')
local appearance = require('config.appearance')

-- Merge configs
return config
```

**WezTerm Specifics:**
- Entry point: `wezterm.lua`
- Modules in `config/` subdirectory
- Use `config_builder()` pattern
- Requires: JetBrainsMono Nerd Font

### Shell Scripts (Zsh)

```bash
# Indentation: 2 spaces
# Common aliases pattern
alias cls='clear'
alias vim='nvim'
alias lg='lazygit'

# Use eza for ls replacement
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias lt='eza -lha --icons=auto --sort=modified'
```

**Zsh Structure:**
- `.zshrc` - Main config, aliases
- `.user.zsh` - Plugins, oh-my-zsh customization
- HyDE integration support

### i3 Window Manager

```i3config
# Indentation: 4 spaces (or tabs per existing style)
# Mod key: Mod4 (Super)
# Font: JetBrainsMono Nerd Font Bold 16

# Include pattern
include ~/.config/i3/windowrules.conf

# Exec pattern for autostart
exec_always --no-startup-id picom
exec_always --no-startup-id ~/.config/polybar/launch.sh
exec --no-startup-id dunst
```

**i3 Dependencies:**
- Core: i3-wm, i3lock, xss-lock
- Audio: pipewire, playerctl, pavucontrol
- Display: brightnessctl, feh (wallpapers)
- Utils: rofi, dunst, autotiling-rs, numlockx
- Terminal: wezterm
- Browser: zen-browser (`/usr/bin/zen-browser`)

### Hyprland Configuration

```conf
# Modular structure
source = ~/.config/hypr/keybindings.conf
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/animations.conf

# Workflow profiles available:
# - default, snappy, gaming, powersaver, editing
```

**Hyprland Structure:**
- Entry: `hyprland.conf` (includes others)
- Modules: animations, keybindings (12KB), monitors, nvidia, windowrules (6KB)
- Subdirs: `animations/`, `hyprlock/`, `shaders/`, `themes/`, `workflows/`
- Theme: `themes/colors.conf`, `themes/theme.conf`
- Lock screen: `hyprlock/HyDE.conf`, `hyprlock/greetd-wallbash.conf`

### tmux Configuration

```tmux
# Prefix: C-e (NOT C-b)
# Terminal: screen-256color with RGB
# Mode: vi keys

# Reload config
bind r source-file ~/.config/tmux/tmux.conf

# Key patterns
bind o run-shell "open #{pane_current_path}"
bind -r h select-pane -L
bind -r j select-pane -D
```

**tmux Specifics:**
- Prefix key: `C-e` (not default `C-b`)
- Vi mode enabled
- Splits open in current directory
- repeat-time: 300ms

## Naming Conventions

| Component | Convention | Example |
|-----------|------------|---------|
| Config files | lowercase, hyphens/underscores | `hyprland.conf`, `window_rules.conf` |
| Lua modules | lowercase, underscores | `config.keys`, `config.appearance` |
| Shell aliases | lowercase | `cls`, `lg`, `ll` |
| i3/Hypr variables | lowercase | `$mod`, `$browser` |

## Important Patterns

### Modular Configuration

Most configs use modular includes:
- **Neovim**: `require()` for Lua modules, `after/plugin/` for post-load
- **WezTerm**: `require('config.module')` pattern
- **i3**: `include` directive
- **Hyprland**: `source =` directive

### Font Dependencies

**Required Font**: JetBrainsMono Nerd Font
- Used by: i3, polybar, wezterm, nvim
- Install: `nerd-fonts` package or manual OTF/TTF install

### Autostart Services (i3)

```i3config
exec_always --no-startup-id picom        # Compositor
exec_always --no-startup-id polybar      # Status bar
exec_always --no-startup-id feh --bg-fill ~/wallpaper.png
exec --no-startup-id dunst               # Notifications
exec --no-startup-id autotiling-rs       # Auto-layout
exec --no-startup-id numlockx on         # Numlock
```

### Color Schemes

Hyprland uses `wallbash` for dynamic theming based on wallpaper colors.

## Component-Specific Notes

### Neovim
See `.config/nvim/AGENTS.md` for comprehensive Neovim guidance (259 lines).

### Zsh
- Plugin manager: oh-my-zsh
- Custom config: `.user.zsh` for plugins, `.zshrc` for aliases
- HyDE integration: Sourced if available

### WezTerm
- Lua-based terminal emulator
- Install: Add `apt.fury.io/wez` repo (Ubuntu/Debian)
- Config pattern: Modular via `config/` directory

### Hyprland Workflows
Pre-configured workflow profiles in `workflows/`:
- `default` - Balanced
- `snappy` - Low-latency animations
- `gaming` - Performance-focused
- `powersaver` - Battery-efficient
- `editing` - Productivity-optimized

## Don't Do

- **i3**: Don't change Mod key from Mod4 without updating all bindings
- **tmux**: Don't change prefix from C-e without updating muscle memory docs
- **Lua configs**: Don't use spaces (tabs only for nvim/wezterm)
- **Hyprland**: Don't edit generated wallbash theme files manually
- **Zsh**: Don't bypass eza aliases with raw `ls` (breaks icon support)

## Testing Changes

| Component | Test Command | Notes |
|-----------|--------------|-------|
| i3 | `i3-msg reload` | Non-destructive reload |
| Hyprland | `hyprctl reload` | Reloads config |
| tmux | `prefix + r` | Bound to reload |
| Zsh | `exec zsh` | Restart shell |
| WezTerm | `wezterm cli spawn` | Test in new pane |
| Neovim | `:Lazy sync` then `:checkhealth` | Plugin-specific |

## External Dependencies

Ensure these are installed for full functionality:
- Nerd Fonts (JetBrainsMono)
- eza (modern ls replacement)
- lazygit (git TUI)
- yazi (file manager)
- starship (prompt)
- picom (compositor)
- dunst (notifications)
- rofi / ulauncher (app launchers)
