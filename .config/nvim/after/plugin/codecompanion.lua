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
					model = "gpt-5-mini",
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
				groups = {
					['beast_tools'] = {
						tools = {
							"neovim",
							"filesystem",
							"cmd_runner",
							"fetch_webpage",
							"file_search",
							"get_changed_files",
							"grep_search",
							"insert_edit_into_file",
							"list_code_usages",
							"next_edit_suggestion",
							"read_file",
							"search_web",
							"mcp",
						},
						prompt =
						"You have access to the following tools. Use them wherever necessary and mention them in your code and workflow. For file and directory operations, always use Neovim tools first. If a Neovim tool fails or is unavailable, use the corresponding filesystem tool.",
						collapse_tools = true,
					}
				},
				opts = {
					auto_submit_errors = true, -- Send any errors to the LLM automatically?
					auto_submit_success = true, -- Send any successful output to the LLM automatically?
				}
			}
		}
	},
	adapters = {
		http = {
			ollama = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					schema = {
						model = {
							default = "claude-sonnet-4",
						},
					},
					env = {
						url = "http://localhost:4000",
					},
				})
			end,
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gpt-4.1"
						}
					}
				})
			end,
		}
	}
})
