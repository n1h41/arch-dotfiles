-- Load which-key library safely, return if not found
local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Return if CodeCompanion plugin is not loaded
if not package.loaded["codecompanion"] then
  return
end

-- Define keymaps for CodeCompanion plugin
wk.add({
  -- Normal mode mappings
  {
    "<leader>c",
    group = "CodeCompanion",
    {
      "<leader>cc", "<cmd>CodeCompanionChat<CR>", desc = "Open AI Chat", mode = "n"
    },
    {
      "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle Chat", mode = "n"
    },
    {
      "<C-c>", "<cmd>CodeCompanionActions<CR>", desc = "Toggle Actions", mode = "n"
    },
    {
      "<leader>cx", "<cmd>CodeCompanionCmd<CR>", desc = "Generate command line commands", mode = "n"
    },
    -- Visual mode mappings
    {
      "<leader>cc", "<cmd>'<,'>CodeCompanion <CR>", desc = "Inline Refactor", mode = "v"
    }
  }
})

