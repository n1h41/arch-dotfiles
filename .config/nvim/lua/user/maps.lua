-- Keymaps configuration
-- This file defines custom key bindings for improved navigation, window management, and editing.
-- See the summary table below for a quick reference.
--
-- NOTE: All mappings use space as the <leader> key (see vim.g.mapleader below).

--[[
Custom Keymaps Summary

| Mode | Key(s)         | Action/Command                                 | Description                        |
|------|----------------|------------------------------------------------|------------------------------------|
| n    | x              | "_x                                            | Delete char without yanking        |
| n    | +              | <C-a>                                          | Increment number                   |
| n    | -              | <C-x>                                          | Decrement number                   |
| n    | <C-a>          | gg<S-v>G                                       | Select all                         |
| n    | te             | :tabedit<CR>                                   | New tab                            |
| n    | <Tab>          | gt                                             | Next tab                           |
| n    | <S-Tab>        | gT                                             | Previous tab                       |
| n    | ss             | :split<Return><C-w>w                           | Horizontal split and move          |
| n    | sv             | :vsplit<Return><C-w>w                          | Vertical split and move            |
| n    | <Space><Space> | <C-w>w                                         | Move to next window                |
| n    | sc             | <C-w>c                                         | Close window                       |
| n    | sh/sk/sj/sl    | <C-w>h/<C-w>k/<C-w>j/<C-w>l                    | Move to window (left/up/down/right)|
| n    | sH/sK/sJ/sL    | <C-w>H/<C-w>K/<C-w>J/<C-w>L                    | Move window (left/up/down/right)   |
| n    | s<left>        | <C-w>>                                         | Resize window (increase width)     |
| n    | s<right>       | <C-w><                                         | Resize window (decrease width)     |
| n    | s<up>          | <C-w>+                                         | Resize window (increase height)    |
| n    | s<down>        | <C-w>-                                         | Resize window (decrease height)    |
| n    | <S-A-f>        | <cmd>lua vim.lsp.buf.format()<CR>              | Format buffer (LSP)                |
| n    | <C-i>          | <C-i>                                          | Jump forward in jumplist           |
| n    | <leader>fn     | :let @+=expand("%:t")<CR>                      | Copy current file name to clipboard|
| n    | <leader>fj     | :.!jq<CR>                                      | Format current line as JSON        |

- `vim.g.mapleader = ' '` sets the leader key to space.
]] --

local keymap = vim.keymap

-- Delete character under cursor without yanking
keymap.set('n', 'x', '"_x')

-- Set <leader> key to space
vim.g.mapleader = ' '

-- Increment/decrement numbers under cursor
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Select all text in buffer
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- New tab
keymap.set('n', 'te', ':tabedit<CR>')

-- Tab navigation
keymap.set('n', '<Tab>', 'gt')      -- Next tab
keymap.set('n', '<S-Tab>', 'gT')    -- Previous tab

-- Window splits
keymap.set('n', 'ss', ':split<Return><C-w>w')    -- Horizontal split and move to it
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')   -- Vertical split and move to it

-- Window navigation
keymap.set('n', '<Space><Space>', '<C-w>w')      -- Move to next window
keymap.set('n', 'sc', '<C-w>c')                  -- Close current window
keymap.set('', 'sh', '<C-w>h')                   -- Move to left window
keymap.set('', 'sk', '<C-w>k')                   -- Move to upper window
keymap.set('', 'sj', '<C-w>j')                   -- Move to lower window
keymap.set('', 'sl', '<C-w>l')                   -- Move to right window

-- Move window to edge
keymap.set('', 'sH', '<C-w>H')                   -- Move window far left
keymap.set('', 'sK', '<C-w>K')                   -- Move window to top
keymap.set('', 'sJ', '<C-w>J')                   -- Move window to bottom
keymap.set('', 'sL', '<C-w>L')                   -- Move window far right

-- Resize windows
keymap.set('n', 's<left>', '<C-w>>')             -- Increase width
keymap.set('n', 's<right>', '<C-w><')            -- Decrease width
keymap.set('n', 's<up>', '<C-w>+')               -- Increase height
keymap.set('n', 's<down>', '<C-w>-')             -- Decrease height

-- Format buffer using LSP
keymap.set("n", "<S-A-f>", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })

-- Jump forward in jumplist (default mapping, for clarity)
keymap.set('n', "<C-i>", "<C-i>", { noremap = true })

-- Copy current file name to clipboard
keymap.set('n', '<leader>fn', ':let @+=expand("%:t")<CR>')

-- Format current line as JSON using jq
keymap.set('n', '<leader>fj', ':.!jq<CR>')

--[[
Unmapped but available for future use:
-- Delete a word backwards without yanking
-- keymap.set('n', 'dw', 'vb"_d')
-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})
]]
