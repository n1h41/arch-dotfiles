# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a comprehensive Neovim configuration built with Lua, using lazy.nvim as the plugin manager. The config is designed for full-stack development with special focus on Flutter/Dart, Go, TypeScript/JavaScript, HTML/CSS (with Tailwind and HTMX support), C/C++, and QML.

## Architecture

The configuration follows a strict modular architecture with clear separation of concerns:

### Core Structure
- `init.lua` - Main entry point with `safe_require()` wrapper for graceful error handling
- `lua/user/` - Core user configuration modules
  - `base.lua` - Core Neovim settings, options, autocommands, and filetype configurations
  - `plugin.lua` - Complete plugin specifications for lazy.nvim with dependency management
  - `maps.lua` - Base keymaps and leader key configuration (`<Space>` as leader)
  - `highlights.lua` - Custom highlight groups and color definitions
- `after/plugin/` - Plugin-specific configurations that load after plugins are initialized
- `after/plugin/keymap/` - Plugin-specific keymaps organized by functionality

### Plugin Loading Strategy
Uses lazy.nvim with aggressive lazy loading for optimal startup performance. Plugins are loaded based on:
- File types (`ft = { "dart", "flutter" }`)
- Commands (`cmd = { "Neotest", "NeotestRun" }`)
- Events (`event = "VeryLazy"`, `event = "BufRead"`)
- Key mappings with proper dependency chains

### LSP Architecture
Modern LSP setup using `vim.lsp.config` (nvim 0.11+) instead of deprecated lspconfig:

**Language Servers:**
- `lua_ls` - Lua with Neovim runtime integration
- `gopls` - Go with templ support (`"go", "gomod", "gowork", "gotmpl"`)
- `html` + `htmx` - HTML with HTMX language support
- `tailwindcss` - Tailwind CSS with templ file support
- `clangd` - Custom ESP-IDF path (`/home/n1h41/tools/esp-clang/bin/clangd`)
- `qmlls` - QML Language Server
- `omnisharp` - C# Language Server
- `hyprls` - Auto-started for Hyprlang files (`.hl`, `hypr*.conf`)

**Special LSP Features:**
- Flutter LSP via flutter-tools.nvim with debugging integration
- Custom templ formatter that runs `templ fmt` before LSP formatting
- Modern diagnostic configuration with custom icons and signs

## Common Development Commands

### Testing Commands
```vim
" Neotest - Run tests for multiple languages
<leader>tr   " Run nearest test
<leader>td   " Debug nearest test (uses dap-go for Go files)
<leader>tw   " Toggle test summary window
<leader>to   " Toggle output window
<leader>tO   " Toggle output panel
<leader>tc   " Clear output panel
```

### Flutter Development
```vim
" Flutter Tools - Complete Flutter workflow
<leader>fe   " List and select emulators
<leader>fd   " List and select devices
<leader>fc   " Copy profiler URL
<leader>fl   " Clear Flutter logs
<leader>fq   " Quit Flutter app
<leader>fo   " Toggle Flutter outline
<leader>fO   " Toggle Flutter log
<leader>hr   " Hot reload
<leader>hR   " Hot restart (full restart)

" Run Flutter with DTD support (for debugging)
:FlutterRun  " Automatically includes --print-dtd flag
```

### Debugging (DAP)
```vim
" Debug controls (F-key bindings for familiarity)
<F5>         " Continue/Start debugging
<F9>         " Toggle breakpoint
<F10>        " Step over
<F11>        " Step into

" Leader-based debug controls
<leader>dt   " Toggle breakpoint
<leader>dc   " Continue
<leader>di   " Step into
<leader>do   " Step over
<leader>dq   " Quit debugger
<leader>dx   " Terminate
<leader>dui  " Toggle DAP UI
<leader>dus  " Open DAP UI sidebar

" Language-specific debugging
<leader>gdt  " Debug Go test (dap-go)
<leader>gdl  " Debug last Go test
<leader>dl   " Launch OSV (Neovim Lua debugging)
```

### File Operations & Navigation
```vim
" Telescope - Fuzzy finding
<leader>ff   " Find files (includes hidden, respects .gitignore)
<leader>fr   " Live grep (search content in files)
<leader>ht   " Help tags
<leader>aC   " List all available commands

" File management
<leader>fn   " Copy current filename to clipboard
<leader>fj   " Format current line as JSON using jq
```

### LSP Operations (Modern Glance + Telescope)
```vim
" Glance.nvim - Modern LSP UI with peek functionality
gd           " Go to definition (glance preview)
gD           " Go to declaration (same as gd)
gr           " Show references in glance UI
gt           " Show type definitions in glance UI
gi           " Show implementations in glance UI
gh           " Show references (unified finder view)
gp           " Peek definition (same as gd in glance)

" Built-in LSP functions
K            " Hover documentation
<leader>ca   " Code actions
<leader>rn   " Rename symbol
<C-k>        " Signature help

" Telescope LSP - Alternative fuzzy finder interface
<leader>ls   " Document symbols
<leader>lw   " Workspace symbols
<leader>lr   " LSP references (telescope view)
<leader>li   " LSP implementations (telescope view)
<leader>ld   " LSP definitions (telescope view)
<leader>lt   " Type definitions (telescope view)

" Workspace management
<leader>wa   " Add workspace folder
<leader>wr   " Remove workspace folder
<leader>wl   " List workspace folders
<leader>D    " Type definition (built-in)

" Diagnostics
<leader>sl   " Show line diagnostics (floating window)
<leader>sc   " Show cursor diagnostics (same as line)
<leader>ds   " Buffer diagnostics (telescope)
<leader>dw   " Workspace diagnostics (telescope)
[e           " Previous diagnostic
]e           " Next diagnostic
[E           " Previous error (ERROR severity only)
]E           " Next error (ERROR severity only)

" Call hierarchy
<leader>ci   " Incoming calls
<leader>co   " Outgoing calls
```

### AI/Code Assistance
```vim
" CodeCompanion - AI-powered development
<leader>cc   " Open AI chat (normal mode)
<leader>ct   " Toggle AI chat
<C-c>        " AI actions menu
<leader>cx   " Generate command line commands
" In visual mode: '<,'>CodeCompanion for inline refactoring

" OpenCode - Alternative LLM integration
<leader>ot   " Toggle OpenCode
<leader>oa   " Ask OpenCode
<leader>oA   " Ask OpenCode about cursor position
<leader>on   " New OpenCode session
<leader>oy   " Copy last OpenCode response
<leader>os   " Select OpenCode prompt
```

### Code Formatting
```vim
" Primary formatting
<S-A-f>      " Smart format: LSP for most files, templ fmt for .templ files

" Language-specific formatting (via conform.nvim)
" - Assembly files (.nasm, .s, .S): asmfmt
" - Format-on-save enabled with 500ms timeout
" - Falls back to LSP formatting when conform formatter unavailable
```

## Development Workflows

### Flutter/Dart Development Pipeline
1. **Project Setup:** Flutter SDK at `/home/n1h41/development/flutter/bin/flutter`
2. **Development:** LSP provides completion, diagnostics, and code actions
3. **Testing:** `<leader>tr` for single tests, `<leader>td` for debugging tests
4. **Hot Reload:** `<leader>hr` for quick changes, `<leader>hR` for full restart
5. **Debugging:** Full DAP integration with Flutter DevTools
6. **Code Quality:** Custom Flutter formatting workflow via CodeCompanion

### Go Development Pipeline
1. **LSP Support:** gopls with templ file support for Go web development
2. **Testing:** Neotest integration with go test
3. **Debugging:** nvim-dap-go for test and application debugging
4. **Templ Files:** Custom formatter runs `templ fmt` before LSP formatting

### Database Development
```vim
" nvim-dbee - Database management
" Configuration handles automatic driver installation
" Integrated with cmp-dbee for SQL autocompletion
```

### Testing Architecture
Multi-language test runner via Neotest:
- **Dart/Flutter:** `neotest-dart` with Flutter command integration
- **Go:** `neotest-go` for standard go test
- **Lua:** `neotest-plenary` for Neovim plugin testing
- **Debugging:** Language-specific debug adapters (dap-go for Go tests)

## Important Configuration Details

### File Type Handling
- **Templ files:** Auto-detected, custom formatter, Tailwind CSS support
- **Assembly:** `.nasm/.s/.S` files with asmfmt formatting
- **Hyprlang:** Auto-LSP startup for `.hl` and `hypr*.conf` files
- **Project configs:** Supports `.nvim.lua` and `.vimrc` (security: `exrc = true`)

### Development Environment Settings
- **Shell:** zsh integration
- **Clipboard:** System clipboard enabled (`unnamedplus`)
- **Indentation:** Tabs preferred (tabstop=2, shiftwidth=2), except C# (4 spaces)
- **Scrolling:** 22-line scroll offset for better context
- **File reload:** Automatic reload when files change externally

### Critical Paths
- **Flutter SDK:** `/home/n1h41/development/flutter/bin/flutter`
- **ESP-IDF clangd:** `/home/n1h41/tools/esp-clang/bin/clangd`
- **Local plugins:** `/home/n1h41/dev/nvim/personal/` (for development)
- **Terminal:** Kitty for external terminal debugging

### Plugin Integration Points
- **Mason:** Auto-installs LSP servers (`lua_ls`, `gopls`, `html`, `emmet_language_server`, `tailwindcss`, `htmx`, `templ`)
- **Treesitter:** Syntax highlighting with context support
- **DAP:** Multi-language debugging with UI, virtual text, and telescope integration
- **Git:** Multiple integrations (gitsigns, neogit, diffview, fugitive)
- **LSP UI:** Glance.nvim for modern peek/preview functionality, Telescope for fuzzy LSP navigation
- **AI Tools:** CodeCompanion with custom workflows, OpenCode, Copilot (disabled by default)