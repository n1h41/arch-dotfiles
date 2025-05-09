-- Load which-key library safely, return if not found
local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Return if CodeCompanion plugin is not loaded
if not package.loaded["codecompanion"] then
  return
end

-- Setup which-key mappings for CodeCompanion plugin
wk.add({
  { "<leader>cc", "<cmd>CodeCompanionChat<CR>", desc = "Open AI Chat",                   mode = "n" },
  { "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle AI Chat",                 mode = "n" },
  { "<C-c>",      "<cmd>CodeCompanionActions<CR>",     desc = "AI Actions",                     mode = "n" },
  { "<leader>cx", "<cmd>CodeCompanionCmd<CR>",         desc = "Generate command line commands", mode = "n" },
  { "<leader>cc", "<cmd>'<,'>CodeCompanion <CR>",      desc = "Inline Refactor",                mode = "v" },
}, {
  silent = true,  -- Don't echo commands
  noremap = true, -- Non-recursive mapping
  nowait = false, -- Wait for additional keypresses
  -- buffer = nil,   -- Apply to all buffers
})
