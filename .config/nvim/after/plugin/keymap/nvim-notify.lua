local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

whichkey.add({
  -- Group registration
  { "c",  group = "Commands" },

  -- Notify command
  { "cn", "<cmd>lua require('notify').dismiss()<cr>", desc = "Close all notifications" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})

