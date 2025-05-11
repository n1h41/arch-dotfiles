require("mcphub").setup({
  port = 37373,                                            -- Default port for MCP Hub
  config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path to config file location (will create if not exists)
  native_servers = {},                                     -- add your native servers here

  auto_approve = true,                                     -- Auto approve mcp tool calls
  auto_toggle_mcp_servers = true,                          -- Let LLMs start and stop MCP servers automatically
  -- Extensions configuration
  extensions = {
    avante = {
      make_slash_commands = true, -- make /slash commands from MCP server prompts
    },
    codecompanion = {
      -- Show the mcp tool result in the chat buffer
      -- NOTE:if the result is markdown with headers, content after the headers wont be sent by codecompanion
      show_result_in_chat = false,
      make_vars = true,           -- make chat #variables from MCP server resources
      make_slash_commands = true, -- make /slash commands from MCP server prompts
    },
  },

  -- Default window settings
  ui = {
    window = {
      width = 0.8,  -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
      height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
      relative = "editor",
      zindex = 50,
      border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
    },
    wo = {                -- window-scoped options (vim.wo)
    },
  },

  -- Event callbacks
  on_ready = function(_)
    -- Called when hub is ready
  end,
  on_error = function(_)
    -- Called on errors
  end,

  --set this to true when using build = "bundled_build.lua"
  use_bundled_binary = false, -- Uses bundled mcp-hub script instead of global installation

  shutdown_delay = 600000,    -- Delay in ms before shutting down the server when last instance closes (default: 10 minutes)

  -- Logging configuration
  log = {
    level = vim.log.levels.WARN,
    to_file = false,
    file_path = nil,
    prefix = "MCPHub",
  },
})
