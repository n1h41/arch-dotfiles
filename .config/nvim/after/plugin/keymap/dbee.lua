-- Load which-key library safely, return if not found
local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Return if CodeCompanion plugin is not loaded
if not package.loaded["dbee"] then
  return
end

-- Setup which-key mappings for CodeCompanion plugin
wk.add({
  { "<leader>db", "<cmd>Dbee<CR>", desc = "Open DBee" },
}, {
  silent = true,  -- Don't echo commands
  noremap = true, -- Non-recursive mapping
  nowait = false, -- Wait for additional keypresses
  -- buffer = nil,   -- Apply to all buffers
})

