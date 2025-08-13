-- Base Neovim configuration
-- This file sets core options, encoding, UI, plugin globals, and custom behaviors

-- Clear all autocommands to avoid duplicates
vim.cmd("autocmd!")

-- Encoding settings
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- Completion menu behavior
vim.opt.completeopt = { "menuone", "noselect" }

-- Line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Editor UI and behavior
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = false -- Use tabs, not spaces
vim.opt.scrolloff = 22 -- Keep 22 lines above/below cursor
vim.opt.shell = 'zsh' -- Use zsh as shell
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split' -- Live preview of :s/:substitute
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.tabstop = 2 -- Tab width
vim.opt.wrap = false         -- No Wrap lines
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' } -- Ignore node_modules in file search
vim.opt.splitright = true -- Vertical splits open right
vim.opt.splitbelow = true -- Horizontal splits open below

-- Use system clipboard
vim.opt.clipboard:append { 'unnamedplus' }

-- Conceal level for markdown, etc.
vim.opt_local.conceallevel = 3

-- Undercurl support in terminal
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = '*',
	command = "set nopaste"
})

-- Add asterisks in block comments when pressing Enter
vim.opt.formatoptions:append { 'r' }

-- Set dark background for colorschemes
vim.o.background = "dark"

-- Auto-reload files changed outside of Neovim
vim.o.autoread = true

-- Neovide GUI settings (only applies if running in Neovide)
vim.g.neovide_scale_factor = 0.7
vim.g.neovide_fullscreen = true
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_cursor_trail_size = 0.3
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10

-- GitHub Copilot: disable in TelescopePrompt
vim.g.copilot_filetypes = {
	TelescopePrompt = false,
}

-- Remove tilde (~) character at end of buffer, customize message separator
vim.opt.fillchars = {
	-- fold = ' ',
	-- vert = '|',
	eob = ' ',
	msgsep = '‾',
}

-- Custom indentation for C# files
vim.api.nvim_create_autocmd("FileType", {
	pattern = 'cs',
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end
})

-- Octo.nvim: set default GitHub username
vim.g.octo_viewer = "n1h41"

-- Allow project-specific .nvim.lua/.vimrc files (security risk if not trusted)
vim.o.exrc = true

-- Add custom filetype for .templ files
vim.filetype.add({ extension = { templ = "templ" } })

-- Vimtex (LaTeX) plugin configuration
vim.cmd([[filetype plugin indent on]])
-- vim.cmd([[syntax enable]])
vim.g.vimtex_compiler_enabled = true
vim.cmd([[let g:tex_flavor = 'latex']])
vim.cmd([[let g:vimtex_view_method = 'zathura']])
vim.cmd([[let g:vimtex_view_general_viewer = 'zathura']])
vim.cmd([[let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex']])
vim.cmd([[let g:vimtex_compiler_method = 'latexmk']])
vim.cmd([[let maplocalleader = ',']])

-- Hyprlang LSP: start hyprls for .hl and hypr*.conf files
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
	pattern = { "*.hl", "hypr*.conf" },
	callback = function(event)
		print(string.format("starting hyprls for %s", vim.inspect(event)))
		vim.lsp.start {
			name = "hyprlang",
			cmd = { "hyprls" },
			root_dir = vim.fn.getcwd(),
		}
	end
})

-- Add hyprlang filetype for hypr config files in any /hypr/ directory
vim.filetype.add({
	pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

-- Neovide-only font config
if vim.g.neovide then
	vim.o.guifont = "JetBrainsMono Nerd Font"
end

-- Custom diagnostic symbols in signcolumn
local symbols = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
for name, icon in pairs(symbols) do
	local hl = "DiagnosticSign" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

-- rest.nvim plugin global (empty table for config)
vim.g.rest_nvim = {}

-- Markdown: turn off signcolumn and enable line wrap
vim.api.nvim_create_autocmd("FileType", {
	pattern = 'markdown',
	command = "set signcolumn=no"
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	command = "set wrap"
})

-- Add filetype for NASM assembly files
vim.filetype.add({
	extension = {
		nasm = 'nasm',
		s = 'nasm',
		S = 'nasm',
	},
	filename = {
		['*.nasm'] = 'nasm',
		['*.inc'] = 'nasm',
	},
})

-- CodeCompanion: enable auto tool mode
vim.g.codecompanion_auto_tool_mode = true
