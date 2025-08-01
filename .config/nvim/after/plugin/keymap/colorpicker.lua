local status, wk = pcall(require, "which-key")
if (not status) then return end

wk.add({
  { "<leader>pc", "<cmd>PickColor<cr>",       desc = "Color Picker",        mode = "n" },
  { "<leader>pC", "<cmd>PickColorInsert<cr>", desc = "Color Picker Insert", mode = "n" },
}, {
  silent = true,
  noremap = true,
  nowait = false,
  buffer = nil,
})
