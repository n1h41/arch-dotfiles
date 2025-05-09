local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Using the new which-key API format for v3
wk.add({
  -- Define group name
  { "t",  group = "Toggle" },

  -- Zen Mode command
  { "tt", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
}, {
  mode = "n", -- Adding default mode since it wasn't specified in original
  silent = true,
  noremap = true,
})

