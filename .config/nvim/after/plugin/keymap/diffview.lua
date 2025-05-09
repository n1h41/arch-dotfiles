local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Function to check if Diffview is currently open
local function is_diffview_open()
  -- Check if the Diffview module is loaded
  local has_diffview, diffview = pcall(require, "diffview")
  if not has_diffview then
    return false
  end

  -- Check if diffview state is available and has an active view
  if diffview.lib and diffview.lib.get_current_view() then
    return true
  end

  return false
end

-- Using the new which-key API format for v3
wk.add({
  -- Define group names first
  { "<leader>d", group = "Diff" },
  { "<leader>t", group = "Toggle" },
  { "<leader>f", group = "File" },

  -- Then define individual mappings with conditional display
  {
    "<leader>dv",
    "<cmd>DiffviewOpen<cr>",
    desc = "Open Diffview",
    cond = function() return not is_diffview_open() end
  },
  {
    "dq",
    "<cmd>DiffviewClose<cr>",
    desc = "Close Diffview",
    -- cond = function() return is_diffview_open() end
  },
  { "<leader>th", "<cmd>DiffviewFileHistory<cr>",   desc = "Toggle all File History" },
  { "<leader>fh", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})
