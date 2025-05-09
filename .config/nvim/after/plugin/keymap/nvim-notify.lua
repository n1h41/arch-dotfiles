local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Using the new which-key API format for v3
wk.add({
  -- Define group name
  { "c", group = "Close" },
  -- Notification dismiss command
  { "cn", "<cmd>lua require('notify').dismiss()<cr>", desc = "Close all notifications" }
}, {
  -- These options apply to all mappings
  mode = "n", -- Adding default mode since it wasn't specified in original
  silent = true,
  noremap = true,
})

