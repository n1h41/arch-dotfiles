-- Glance.nvim configuration
-- Modern LSP UI replacement for lspsaga providing peek definitions, references, implementations, and type definitions

local status, glance = pcall(require, "glance")
if not status then
	return
end

-- Configure glance with rounded borders and enhanced UI
glance.setup({
	height = 18, -- Height of the window
	zindex = 45,
	-- Preview window configuration
	preview_win_opts = {
		cursorline = true,
		number = true,
		wrap = true,
	},
	-- List window configuration
	list = {
		position = 'right',
		width = 0.33, -- 33% of screen width
	},
	theme = {
		enable = true, -- Will use colorscheme colors by default
		mode = 'auto', -- 'brighten'|'darken'|'auto' (auto mode uses colorscheme's mode)
	},
	-- Mapping configuration
	mappings = {
		list = {
			['j'] = glance.actions.next, -- Bring the cursor to the next item in the list
			['k'] = glance.actions.previous, -- Bring the cursor to the previous item in the list
			['<Down>'] = glance.actions.next,
			['<Up>'] = glance.actions.previous,
			['<Tab>'] = glance.actions.next_location, -- Bring the cursor to the next location skipping groups in the list
			['<S-Tab>'] = glance.actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
			['<C-u>'] = glance.actions.preview_scroll_win(5),
			['<C-d>'] = glance.actions.preview_scroll_win(-5),
			['v'] = glance.actions.jump_vsplit,
			['s'] = glance.actions.jump_split,
			['t'] = glance.actions.jump_tab,
			['<CR>'] = glance.actions.jump,
			['o'] = glance.actions.jump,
			['l'] = glance.actions.open_fold,
			['h'] = glance.actions.close_fold,
			['<leader>l'] = glance.actions.enter_win('preview'), -- Focus preview window
			['q'] = glance.actions.close,
			['Q'] = glance.actions.close,
			['<Esc>'] = glance.actions.close,
		},
		preview = {
			['Q'] = glance.actions.close,
			['<Tab>'] = glance.actions.next_location,
			['<S-Tab>'] = glance.actions.previous_location,
			['<leader>l'] = glance.actions.enter_win('list'), -- Focus list window
		},
	},
	hooks = {},
	folds = {
		fold_closed = '',
		fold_open = '',
		folded = true, -- Automatically fold list on startup
	},
	indent_lines = {
		enable = true,
		icon = '│',
	},
	winbar = {
		enable = true, -- Available strating from nvim-0.8+
	},
})

-- Keymaps configuration to replicate lspsaga functionality
local opts = { noremap = true, silent = true }

-- Glance commands (replaces lspsaga finder, peek_definition, etc.)
vim.keymap.set('n', 'gd', '<CMD>Glance definitions<CR>', opts)
vim.keymap.set('n', 'gD', '<CMD>Glance definitions<CR>', opts) -- Same as gd for simplicity
vim.keymap.set('n', 'gr', '<CMD>Glance references<CR>', opts)
vim.keymap.set('n', 'gt', '<CMD>Glance type_definitions<CR>', opts)
vim.keymap.set('n', 'gi', '<CMD>Glance implementations<CR>', opts)

-- LSP finder equivalent - shows references in a unified view
vim.keymap.set('n', 'gh', '<CMD>Glance references<CR>', opts)

-- Peek equivalents - glance already provides preview functionality
vim.keymap.set('n', 'gp', '<CMD>Glance definitions<CR>', opts)

-- Built-in LSP functions for features not covered by glance
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- Hover documentation
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- Code actions
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- Rename (changed from 'gr' to avoid conflict)

-- Diagnostic navigation (enhanced from lspsaga)
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']e', vim.diagnostic.goto_next, opts)

-- Diagnostic jump with error severity only
vim.keymap.set('n', '[E', function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, opts)
vim.keymap.set('n', ']E', function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, opts)

-- Diagnostic display (replaces lspsaga show_line_diagnostics, etc.)
vim.keymap.set('n', '<leader>sl', vim.diagnostic.open_float, opts) -- Show line diagnostics
vim.keymap.set('n', '<leader>sc', vim.diagnostic.open_float, opts) -- Show cursor diagnostics (same as line)

-- These will be handled by enhanced Trouble.nvim configuration
-- vim.keymap.set('n', '<leader>sb', '<cmd>Trouble document_diagnostics<cr>', opts) -- Buffer diagnostics
-- vim.keymap.set('n', '<leader>sw', '<cmd>Trouble workspace_diagnostics<cr>', opts) -- Workspace diagnostics

-- Call hierarchy (using built-in LSP)
vim.keymap.set('n', '<leader>ci', vim.lsp.buf.incoming_calls, opts)
vim.keymap.set('n', '<leader>co', vim.lsp.buf.outgoing_calls, opts)