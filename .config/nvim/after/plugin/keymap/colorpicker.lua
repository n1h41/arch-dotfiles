local status, wk = pcall(require, "which-key")
if (not status) then return end

wk.add({
  { "<leader>cp", "<cmd>PickColor<cr>", desc = "Color Picker", mode = "n" },
  { "<leader>cP", "<cmd>PickColorInsert<cr>", desc = "Color Picker Insert", mode = "n" },
}, {
  silent = true,
  noremap = true,
  nowait = false,
  buffer = nil,
})
