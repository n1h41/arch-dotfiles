local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

whichkey.add({
  -- Group registration
  { "t",  group = "Trouble" },

  -- Trouble command
  { "tl", "<cmd>Trouble<CR>", desc = "List" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})

