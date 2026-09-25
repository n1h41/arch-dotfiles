-- Basic Settings
vim.opt_local.cursorcolumn = true -- Highlight the current column
vim.opt_local.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt_local.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt_local.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt_local.expandtab = true -- Expand tab to 2 spaces

-- Folding
vim.opt_local.foldmethod = "indent"
vim.opt_local.foldlevel = 1

-- Keymaps (buffer-local; zj/zk already navigate folds natively)
local opts = { noremap = true, silent = true, buffer = 0 }

vim.keymap.set("n", "<leader>yl", function()
	vim.cmd("silent !yamllint %")
end, vim.tbl_extend("force", opts, { desc = "Lint YAML file" }))

vim.keymap.set("n", "]]", function()
	require("user.yaml_helper").goto_next_same_indent()
end, vim.tbl_extend("force", opts, { desc = "Go to next block at same indent" }))

vim.keymap.set("n", "[[", function()
	require("user.yaml_helper").goto_prev_same_indent()
end, vim.tbl_extend("force", opts, { desc = "Go to previous block at same indent" }))
