-- Highlight and UI settings

vim.opt.cursorline = true         -- Highlight the current line
vim.opt.termguicolors = true      -- Enable 24-bit RGB colors
vim.opt.winblend = 0              -- No transparency for floating windows
vim.opt.wildoptions = 'pum'       -- Show completion matches in popup menu
vim.opt.pumblend = 0              -- No transparency for popup menu
vim.opt.background = 'dark'       -- Use dark background for colorschemes

-- Highlight yanked text for 100ms using the "Visual" highlight group
vim.cmd [[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=100})
  augroup END
]]
