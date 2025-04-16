local status, copilotChat = pcall(require, "CopilotChat")
if not status then
  return
end

copilotChat.setup({
  model = "claude-3.7-sonnet",
  mappings = {
    complete = {
      insert = "<A-Space>",
    }
  }
})
