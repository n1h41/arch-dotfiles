local status, wk = pcall(require, "which-key")
if not status then
  return
end

-- Using the new which-key API format for v3
wk.add({
  -- Define group name
  { "<leader>p",  group = "PlatformIO" },

  -- PlatformIO commands
  { "<leader>pr", "<cmd>Piorun<cr>",   desc = "PlatformIO Run" },
  { "<leader>pm", "<cmd>Piomon<cr>",   desc = "PlatformIO Monitor" },
}, {
  mode = 'n',
  silent = true,
  noremap = true,
  nowait = true,
})

