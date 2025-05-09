local status, wk = pcall(require, "which-key")
if (not status) then return end

wk.add({
  { "<leader>xx", "<cmd>Trouble<cr>",                      desc = "Trouble Toggle",        mode = "n" },
  { "<leader>xt", "<cmd>Trouble todo<cr>",                 desc = "Trouble Toggle",        mode = "n" },
  { "<leader>xw", "<cmd>Trouble diagnostics<cr>",          desc = "Workspace Diagnostics", mode = "n" },
  { "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", desc = "Document Diagnostics",  mode = "n" },
  { "<leader>xq", "<cmd>Trouble quickfix<cr>",             desc = "Quickfix",              mode = "n" },
  { "<leader>xl", "<cmd>Trouble loclist<cr>",              desc = "Location List",         mode = "n" },
  { "<leader>xr", "<cmd>Trouble lsp_references<cr>",       desc = "LSP References",        mode = "n" },
}, {
  silent = true,
  noremap = true,
  nowait = false,
  buffer = nil,
})
