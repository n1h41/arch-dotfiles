local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

whichkey.add({
  -- Group registrations
  { "d",  group = "Diffview" },
  { "t",  group = "Toggle" },
  { "f",  group = "File" },

  -- Diffview commands
  { "dv", "<cmd>DiffviewOpen<cr>",          desc = "Open Diffview" },
  { "dq", "<cmd>DiffviewClose<cr>",         desc = "Close Diffview" },
  { "th", "<cmd>DiffviewFileHistory<cr>",   desc = "Toggle all File History" },
  { "fh", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})

