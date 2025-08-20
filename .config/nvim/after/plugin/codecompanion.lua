local status, codecompanion = pcall(require, "codecompanion")
if not status then
	return
end

local workflows = require("user.codecompanion.workflows")

codecompanion.setup({
	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				show_result_in_chat = true, -- Show mcp tool results in chat
				make_vars = true,       -- Convert resources to #variables
				make_slash_commands = true, -- Add prompts as /slash commands
			}
		},
		history = {
			enabled = true,
			opts = {
				keymap = "gh",
				save_chat_keymap = "sc",
				auto_save = false,
				expiration_days = 0,
				picker = "snacks",
				auto_generate_title = true,
				title_generation_opts = {
					adapter = "copilot",
					model = "gpt-4o",
					refresh_every_n_prompts = 0,
					max_refreshes = 3,
				},
				continue_last_chat = false,
				delete_on_clearing_chat = true,
				dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				enable_logging = false,
			}
		}
	},
	prompt_library = workflows,
	strategies = {
		chat = {
			adapter = "copilot",
			roles = {
				llm = function(adapter)
					return string.format("  %s%s", adapter.formatted_name,
						adapter.paramters and (adapter.paramters.model and " (" .. adapter.paramters.model .. ")" or "")
						or ""
					)
				end,
			},
			tools = {
				opts = {
					--[[ default_tools = {
						"neovim",
						"filesystem",
						"fetch_webpage",
						"cmd_runner",
					}, ]]
					auto_submit_errors = true, -- Send any errors to the LLM automatically?
					auto_submit_success = true, -- Send any successful output to the LLM automatically?
				}
			}
		}
	},
	adapters = {
		copilot = function()
			return require("codecompanion.adapters").extend("copilot", {
				schema = {
					model = {
						-- default = "gpt-4.1"
						default = "claude-3.7-sonnet"
					}
				}
			})
		end,
		ollama = function()
			return require("codecompanion.adapters").extend("ollama", {
				schema = {
					model = {
						default = "qwen2.5-coder:7b"
					}
				}
			})
		end
	}
})
