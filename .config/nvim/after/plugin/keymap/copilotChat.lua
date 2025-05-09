local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

if not package.loaded["CopilotChat"] then
  return
end

-- Setup which-key mappings for CopilotChat
wk.add({
  { "<leader>cc", "<cmd>CopilotChatToggle<CR>", desc = "Open Copilot Chat", mode = "n" },
}, {
  silent = true,  -- Don't echo commands
  noremap = true, -- Non-recursive mapping
  nowait = false, -- Wait for additional keypresses
  buffer = nil,   -- Apply to all buffers
})
