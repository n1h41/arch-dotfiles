# AGENTS.md - Neovim Configuration

This document provides guidance for AI coding agents working in this Neovim configuration repository.

## Repository Overview

This is a personal Neovim configuration using **lazy.nvim** as the plugin manager. The configuration is modular, with core settings in `lua/user/` and plugin-specific configs in `after/plugin/`.

## Directory Structure

```
.config/nvim/
├── init.lua                    # Entrypoint - loads core modules with safe_require()
├── lua/
│   ├── user/
│   │   ├── base.lua            # Core Neovim options and settings
│   │   ├── maps.lua            # Global keymaps (leader = space)
│   │   ├── plugin.lua          # lazy.nvim plugin specifications
│   │   ├── highlights.lua      # Custom highlight groups
│   │   └── codecompanion/      # CodeCompanion AI integration utilities
│   └── .luarc.json             # Lua LSP configuration
├── after/plugin/               # Plugin configurations (loaded after plugins)
│   ├── lsp.lua                 # LSP setup (vim.lsp.config style, nvim 0.11+)
│   ├── treesitter.lua          # Treesitter configuration
│   └── keymap/                 # Plugin-specific keymaps
├── plugin/                     # Vim-style plugin configs
└── KEYMAPS.md                  # Keymap documentation
```

## Build/Lint/Test Commands

### No Traditional Build System

This is a Neovim config - there's no build or test pipeline. Validation happens at runtime.

### Validation Approaches

```bash
# Check Lua syntax (from nvim directory)
luacheck lua/ --globals vim

# Validate config loads without errors
nvim --headless -c 'qa'

# Check lazy.nvim plugin health
nvim --headless -c 'checkhealth lazy' -c 'qa'

# Update plugin lockfile
nvim --headless -c 'Lazy sync' -c 'qa'
```

### Plugin Management

```lua
-- Within Neovim:
:Lazy              -- Open lazy.nvim UI
:Lazy sync         -- Update all plugins
:Lazy health       -- Check plugin health
:Mason             -- Manage LSP servers
```

## Code Style Guidelines

### Lua Formatting

| Setting | Value |
|---------|-------|
| Indentation | **Tabs** (not spaces) - see `vim.opt.expandtab = false` |
| Tab width | 2 characters |
| Shift width | 2 characters |
| Line wrap | Disabled (`vim.opt.wrap = false`) |

### File Structure Pattern

```lua
-- 1. Module status check with pcall
local status, module = pcall(require, "module-name")
if not status then return end

-- 2. Configuration
module.setup({
  -- options
})
```

### Error Handling

Always use `pcall` for optional module loading:

```lua
-- CORRECT
local ok, err = pcall(require, module)
if not ok then
  vim.notify('Error loading: ' .. module, vim.log.levels.ERROR)
end

-- INCORRECT - will crash if module missing
local module = require('module')
```

### Keymap Conventions

```lua
-- Use vim.keymap.set with descriptive opts
vim.keymap.set('n', '<leader>xx', function()
  -- action
end, { noremap = true, silent = true, desc = "Description here" })

-- Leader key is SPACE
vim.g.mapleader = ' '
```

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | lowercase with underscores/hyphens | `nvim-tree.lua`, `null_ls.lua` |
| Functions | snake_case | `safe_require()`, `templ_format()` |
| Variables | snake_case | `local mason_status` |
| Plugin specs | lowercase | `'nvim-treesitter/nvim-treesitter'` |
| Autogroups | PascalCase | `LspFormatting`, `LSPDocumentHighlight` |

### Import Order

1. Neovim builtins (`vim.*`)
2. External plugin requires
3. Local module requires

```lua
-- 1. vim APIs first
local keymap = vim.keymap

-- 2. External plugins
local cmp = require('cmp')
local lspkind = require('lspkind')

-- 3. Local modules
local utils = require('user.codecompanion.utils')
```

### Plugin Configuration Pattern

Plugins use lazy.nvim spec format:

```lua
{
  'author/plugin-name',
  lazy = true,                    -- Lazy load when possible
  cmd = { 'PluginCommand' },      -- Load on command
  ft = { 'lua', 'python' },       -- Load on filetype
  event = 'VeryLazy',             -- Load after startup
  dependencies = { 'dep/plugin' },
  config = function()
    require('plugin').setup({})
  end,
  opts = {},                      -- Alternative to config function
}
```

### LSP Configuration (nvim 0.11+)

This config uses the modern `vim.lsp.config` API:

```lua
-- Modern style (used here)
vim.lsp.config.lua_ls = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { ... }
}

-- NOT the deprecated lspconfig style
-- require('lspconfig').lua_ls.setup({})
```

### Diagnostic Suppression

Use `---@diagnostic` comments for intentional suppressions:

```lua
---@diagnostic disable: undefined-doc-name
---@diagnostic disable-next-line: missing-fields
```

### Comment Style

```lua
-- Single line comment

--[[ 
Multi-line comment
Used for disabled code blocks
]]

-- Section headers use uppercase
-- LSP CONFIGURATION
```

## Key Patterns to Follow

### 1. Safe Module Loading

The entrypoint uses `safe_require()` - follow this pattern for optional dependencies.

### 2. Plugin Config Location

- Core plugin specs go in `lua/user/plugin.lua`
- Plugin setup/config goes in `after/plugin/<plugin>.lua`
- Plugin keymaps go in `after/plugin/keymap/<plugin>.lua`

### 3. Autocmd Creation

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
  end
})
```

### 4. User Commands

```lua
vim.api.nvim_create_user_command('CommandName', function(opts)
  -- implementation
end, { desc = "Command description" })
```

## Language-Specific Settings

| Language | Tab Width | Special Config |
|----------|-----------|----------------|
| Default | 2 (tabs) | - |
| C# | 4 (tabs) | See `base.lua` FileType autocmd |
| Markdown | - | signcolumn=no |
| Templ | - | Auto-format on save via `templ fmt` |

## LSP Servers (Mason-managed)

Ensured installed: `lua_ls`, `gopls`, `html`, `emmet_language_server`, `tailwindcss`, `templ`

Additional configured: `clangd`, `qmlls`, `omnisharp`, Flutter/Dart

## Important Files to Know

- `lua/user/base.lua` - All core vim options, read this first
- `lua/user/maps.lua` - Global keymaps reference
- `after/plugin/lsp.lua` - LSP configuration hub
- `lazy-lock.json` - Plugin version lockfile (auto-generated)

## Don't Do

- Don't use `require('lspconfig')` - use `vim.lsp.config` (nvim 0.11+)
- Don't use spaces for indentation - tabs only
- Don't add plugins without lazy-loading strategy
- Don't modify `lazy-lock.json` manually
- Don't use deprecated `vim.fn.sign_define()` for diagnostics
