# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a comprehensive Neovim configuration built with Lua, using lazy.nvim as the plugin manager. The config is designed for full-stack development with special focus on Flutter/Dart, Go, TypeScript/JavaScript, HTML/CSS (with Tailwind and HTMX support), C/C++, and QML.

## Architecture

The configuration follows a modular architecture:

- `init.lua` - Main entry point with safe_require wrapper for error handling
- `lua/user/` - Core user configuration modules
  - `base.lua` - Core Neovim settings, options, and autocommands
  - `plugin.lua` - Plugin specifications for lazy.nvim
  - `maps.lua` - Custom keymaps and leader key configuration
  - `highlights.lua` - Custom highlight groups and colors
- `after/plugin/` - Plugin-specific configurations that load after plugins
- `after/plugin/keymap/` - Plugin-specific keymaps

### Plugin Management

Uses lazy.nvim with lazy loading for optimal startup performance. Plugins are specified in `lua/user/plugin.lua` with proper dependency management and lazy loading triggers.

### LSP Configuration

LSP setup is handled in `after/plugin/lsp.lua` using lsp-zero.nvim with these language servers:
- `lua_ls` - Lua Language Server
- `gopls` - Go Language Server
- `html` - HTML Language Server
- `htmx` - HTMX Language Server
- `tailwindcss` - Tailwind CSS Language Server
- `clangd` - C/C++ Language Server (custom ESP-IDF path)
- `qmlls` - QML Language Server
- `omnisharp` - C# Language Server
- `hyprls` - Hyprlang Language Server (auto-starts for .hl and hypr*.conf files)

Flutter LSP is configured through flutter-tools.nvim with debugging support.

## Development Workflows

### Flutter/Dart Development
- Flutter tools integration with debugging capabilities
- Custom flutter_format workflow via CodeCompanion
- Dart-specific test runners via Neotest
- DTD (Dart Tooling Daemon) support with `--print-dtd` flag
- Custom templ file formatter for Go templ files

### Testing
- Neotest integration for multiple languages:
  - `neotest-dart` for Flutter/Dart tests
  - `neotest-go` for Go tests
  - `neotest-plenary` for Lua tests

### Debugging
- nvim-dap configuration for multiple languages
- Go debugging with nvim-dap-go
- Flutter debugging through flutter-tools.nvim
- JavaScript/Node.js debugging with vscode-node-debug2

### AI/Copilot Integration
- CodeCompanion.nvim for AI-assisted development with custom workflows
- GitHub Copilot integration (disabled by default, use `:Copilot enable`)
- OpenCode.nvim for LLM-powered code assistance
- Custom workflows in `lua/user/codecompanion/workflows/`

### Database Development
- nvim-dbee for database management and exploration
- vim-dadbod integration for SQL queries
- Database completion via cmp-dbee

## Key Custom Keymaps

Leader key is set to `<Space>`. Major custom bindings include:

**Window Management:**
- `ss` - Horizontal split and focus
- `sv` - Vertical split and focus
- `sh/sj/sk/sl` - Navigate between windows
- `sH/sJ/sK/sL` - Move windows to edges
- `s<arrows>` - Resize windows

**Tab Management:**
- `te` - New tab
- `<Tab>/<S-Tab>` - Navigate tabs

**File Operations:**
- `<leader>fn` - Copy current filename to clipboard
- `<leader>fj` - Format current line as JSON with jq

**Formatting:**
- `<S-A-f>` - Format buffer (LSP or templ fmt for .templ files)

## Configuration Notes

### Custom File Types
- `.templ` files (Go templ) with custom formatter
- `.nasm/.s/.S` files for assembly
- Hyprlang files (`.hl`, `hypr*.conf`) with LSP support
- Auto-detection of project-specific config files (`.nvim.lua`, `.vimrc`)

### Development Environment
- Uses zsh as shell
- System clipboard integration enabled
- Tabs preferred over spaces (tabstop=2, shiftwidth=2)
- No line wrapping by default
- 22-line scroll offset for better context

### Theme and UI
- Multiple theme options available (onedark, catppuccin, cyberdream, etc.)
- Lualine status line with custom components
- Buffer line for tab management
- Noice.nvim for enhanced UI notifications
- Custom diagnostic symbols and highlights

### File Management
- nvim-tree for file explorer
- Oil.nvim as alternative file explorer
- Telescope for fuzzy finding with project support
- Automatic file reload when changed externally

## Important Paths and Settings

- Flutter SDK: `/home/n1h41/development/flutter/bin/flutter`
- Custom clangd: `/home/n1h41/tools/esp-clang/bin/clangd` (for ESP-IDF development)
- Local plugin development: `/home/n1h41/dev/nvim/personal/`
- Neovide GUI support with custom settings

## Plugin Ecosystem

Key plugins for development:
- **LSP/Completion:** lsp-zero.nvim, nvim-cmp, mason.nvim
- **Syntax:** nvim-treesitter with context support
- **Git:** gitsigns.nvim, neogit, diffview.nvim, vim-fugitive
- **Testing:** neotest with language-specific adapters
- **Debugging:** nvim-dap with UI and virtual text
- **AI:** codecompanion.nvim, copilot.vim, opencode.nvim
- **File Management:** nvim-tree, oil.nvim, telescope.nvim
- **Terminal:** toggleterm.nvim with floating terminal
- **Markdown:** render-markdown.nvim with LaTeX disabled
- **Database:** nvim-dbee for database exploration