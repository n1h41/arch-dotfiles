local status, wk = pcall(require, "which-key")
if not status then
  return
end

-- Using the new which-key API format for v3
--[[ wk.add({
  -- Define group name
  { "<leader>d",  group = "Database" },

  -- Database UI command
  { "<leader>db", "<cmd>DBUI<cr>",   desc = "Database UI" },
}, {
  mode = 'n',
  silent = true,
  noremap = true,
  nowait = true,
}) ]]

