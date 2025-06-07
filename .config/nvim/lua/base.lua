vim.cmd("autocmd!")

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.completeopt = { "menuone", "noselect" }

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 22
vim.opt.shell = 'zsh'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false         -- No Wrap lines
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.clipboard:append { 'unnamedplus' }

vim.opt_local.conceallevel = 3

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})

-- Add asterisks in block comments
vim.opt.formatoptions:append { 'r' }

-- Colorscheme custom (gruvbox)
vim.o.background = "dark"

vim.o.autoread = true

vim.g.neovide_scale_factor = 0.7
vim.g.neovide_fullscreen = true
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_cursor_trail_size = 0.3
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10

-- copilot

vim.g.copilot_filetypes = {
  TelescopePrompt = false,
}

-- Remove tilde character
vim.opt.fillchars = {
  -- fold = ' ',
  -- vert = '|',
  eob = ' ',
  msgsep = '‾',

}

-- custom indentation for csharp files
vim.api.nvim_create_autocmd("FileType", {
  pattern = 'cs',
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end
})

-- octo
vim.g.octo_viewer = "n1h41"

-- exrc
vim.o.exrc = true

vim.filetype.add({ extension = { templ = "templ" } })

-- Vimtex (Latex)
vim.cmd([[filetype plugin indent on]])
-- vim.cmd([[syntax enable]])

vim.g.vimtex_compiler_enabled = true
vim.cmd([[let g:tex_flavor = 'latex']])

vim.cmd([[let g:vimtex_view_method = 'zathura']])

vim.cmd([[let g:vimtex_view_general_viewer = 'zathura']])
vim.cmd([[let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex']])

vim.cmd([[let g:vimtex_compiler_method = 'latexmk']])

vim.cmd([[let maplocalleader = ',']])


-- Hyprlang LSP
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

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

-- Noevide only configs
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font"
end

-- Custom symbols for diagnostics
local symbols = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }

for name, icon in pairs(symbols) do
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

vim.g.rest_nvim = {}

-- Turn off signcolumn for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = 'markdown',
  command = "set signcolumn=no"
})

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
