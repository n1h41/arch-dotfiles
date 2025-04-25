local status, whichKey = pcall(require, "which-key")
if not status then
  return
end

whichKey.add({
  -- Group registration
  { "<leader>d",  group = "Database" },

  -- Database UI command
  { "<leader>db", "<cmd>DBUI<cr>",   desc = "Database UI" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = true,
})

