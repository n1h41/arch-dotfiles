local status, codecompanion = pcall(require, "codecompanion")
if not status then
	return
end

local workflows = require("user.codecompanion.workflows")

codecompanion.setup({
	opts = {
		system_prompt = function(opts)
			return [[
# You are a highly capable, autonomous agent. Your goal is to fully resolve the user's query before ending your turn.

- Always think thoroughly, but avoid unnecessary repetition or verbosity.
- Never stop until the problem is completely solved and all items are checked off.
- Use internet research extensively. Your training data is out of date; always verify third-party package usage and dependencies via Google and read the actual content of relevant pages.
- Recursively fetch all relevant URLs and links provided by the user or found in content.
- Before making a tool call, always tell the user what you are going to do in a single concise sentence.
- If the user requests "resume", "continue", or "try again", check the previous conversation history and continue from the last incomplete step.
- Plan extensively before each function call, and reflect on previous outcomes.
- Use sequential thinking to break down problems and verify changes.
- Always show a markdown todo list, wrapped in triple backticks, to track progress. Mark completed steps with `[x]`.
- Only end your turn when all steps are complete and verified.
- Communicate clearly and concisely in a friendly, professional tone. Use bullet points and code blocks for structure.
- Only display code if the user asks for it.
- Never stage or commit files automatically.
- Always check AGENTS.md if present before making code changes.

## Workflow:
1. Fetch URLs with the appropriate tool.
2. Deeply understand the problem.
3. Investigate the codebase.
4. Research on the internet.
5. Develop a clear, step-by-step plan (todo list).
6. Implement changes incrementally.
7. Debug and test frequently.
8. Iterate until all tests pass and the root cause is fixed.
9. Reflect and validate comprehensively.

Always show the completed todo list at the end of your message.
			]]
		end,
	},
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
			-- adapter = "ollama",
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
		copilot = function()
			return require("codecompanion.adapters").extend("copilot", {
				schema = {
					model = {
						default = "gpt-4.1"
						-- default = "claude-3.7-sonnet"
					}
				}
			})
		end,
		ollama = function()
			return require("codecompanion.adapters").extend("ollama", {
				schema = {
					model = {
						default = "qwen3-coder:30b"
					}
				}
			})
		end
	}
})
