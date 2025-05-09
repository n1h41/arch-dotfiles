local status, wk = pcall(require, "which-key")
if (not status) then return end

wk.add({
  { "<leader>ce", "<cmd>Copilot enable<CR>",  desc = "Enable Copilot",  mode = "n" },
  { "<leader>cd", "<cmd>Copilot disable<CR>", desc = "Disable Copilot", mode = "n" },
  { "<leader>cs", "<cmd>Copilot status<CR>",  desc = "Status Copilot",  mode = "n" },
  { "<leader>cp", "<cmd>Copilot panel<CR>",   desc = "Copilot panel",   mode = "n" },
}, {
  silent = true,
  noremap = true,
  nowait = false,
  buffer = nil,
})
