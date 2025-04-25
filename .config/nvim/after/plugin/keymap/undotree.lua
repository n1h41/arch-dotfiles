local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

whichkey.add({
  -- Undotree command
  { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})

