local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Using the new which-key API format for v3
wk.add({
  -- Define the undotree command with function reference
  { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})

