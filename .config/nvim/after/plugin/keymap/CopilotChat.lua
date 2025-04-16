local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

whichkey.add(
  { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Open copilot chat", mode = { "n", "v" } }
)
