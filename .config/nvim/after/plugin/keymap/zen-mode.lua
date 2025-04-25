local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

whichkey.add({
  -- Group registration
  { "t",  group = "Toggle" },

  -- Zen Mode command
  { "tt", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})

