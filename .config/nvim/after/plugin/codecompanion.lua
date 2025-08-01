local status, codecompanion = pcall(require, "codecompanion")
if not status then
	return
end

--------------------------------------------------------
-- Helper functions to improve code organization
--------------------------------------------------------

-- Creates a system message with standard formatting
local function create_system_message(content)
	return {
		role = "system",
		content = content,
		opts = {
			visible = false,
		}
	}
end

-- Sets up auto tool mode for content functions
local function with_auto_tool_mode(content_fn)
	return function()
		vim.g.codecompanion_auto_tool_mode = true
		return content_fn()
	end
end

-- Creates a workflow with consistent structure
local function create_workflow(description, index, short_name, prompts, is_default)
	return {
		strategy = "workflow",
		description = description,
		opts = {
			index = index,
			is_default = is_default or true,
			short_name = short_name,
			auto_submit = true,
		},
		prompts = prompts
	}
end

--------------------------------------------------------
-- Workflow Content Definitions
--------------------------------------------------------

-- Dart Refactoring content
local dart_refactor_content = function()
	return [[### Dart Code Refactoring

I need you to perform code refactoring across several Dart files in my Flutter project. Here are the specific replacements I need:

1. Replace all instances of `Dimens.constPadding` with `ISizes.md`
2. Replace all instances of `Dimens.constWidth` with:
```dart
const SizedBox(
  width: ISizes.md,
)
```
3. Replace all instances of `Dimens.constHeight` with:
```dart
const SizedBox(
  height: ISizes.md,
)
```

For each buffer I share with you, please:
1. Scan the entire file for these patterns
2. Apply all the replacements needed
3. Let me know what changes were made in which files]]
end

-- Flutter Format content
local flutter_format_content = function()
	return [[### Flutter Code Formatting

Please help me format my Flutter code according to best practices. When formatting the code, please:

1. Follow the official Dart Style Guide
2. Apply Flutter-specific formatting conventions:
   - Use proper widget structure with consistent indentation
   - Format widget trees for readability (one widget per line for complex widgets)
   - Properly align parameters and trailing commas for enhanced readability
   - Extract repeated widgets into reusable variables or methods
   - Use const constructors where appropriate
   - Format string interpolation consistently
   - Apply proper spacing around operators, brackets, and parentheses
   - Organize import statements according to best practices
   - Add proper documentation for public APIs

3. WITHOUT changing any functional behavior, improve code:
   - Remove redundant code
   - Fix any style issues
   - Improve naming if unclear
   - Simplify complex expressions
   - Apply proper nullable handling practices

Let me know you're ready, and I'll share my Flutter code with you.]]
end

-- Theme Migration content
local theme_migration_content = function()
	return [[### Flutter Theme Migration

I need help transitioning our app's styling approach from using direct AppTextStyles references to using Flutter's ThemeData with extensions. Here's my specific request:

1. Please analyze two files:
   - `/home/nihal/dev/flutter/works/raf-pharmacy/lib/resources/app_textstyles.dart` (our current styling approach)
   - `/home/nihal/dev/flutter/works/innsof_ecommerce/lib/utils/theme/widget_themes/text_theme.dart` (the theme implementation we want to use)

2. Once you've analyzed them, I need you to convert text style references in our UI files (buffers I'll share) from using the AppTextStyles approach to using the context.textTheme extension method.

3. Implementation requirements:
   - Replace all instances of AppTextStyles with context.textTheme.[appropriate style]
   - Make sure to use the textTheme extension method on the BuildContext (context) to access styles
   - Preserve font weight settings by using .copyWith(fontWeight: FontWeight.w###) where necessary
   - If TextStyle has other properties in AppTextStyles, also include those in the copyWith

4. I'll share multiple files sequentially. For each one:
   - Analyze the current usage of AppTextStyles
   - Show me the complete updated code using the theme approach
   - Apply the changes to the buffer when requested

Please first examine the two reference files I mentioned so you understand both approaches thoroughly before making changes.]]
end

-- File analysis request content
local theme_files_analysis_content = function()
	return [[Please use the @mcp tool to analyze these two files:
1. `/home/nihal/dev/flutter/works/raf-pharmacy/lib/resources/app_textstyles.dart`
2. `/home/nihal/dev/flutter/works/innsof_ecommerce/lib/utils/theme/widget_themes/text_theme.dart`

Provide a mapping between the styles in AppTextStyles and the equivalent in the textTheme extension approach, explaining how you'll transform them.]]
end

--------------------------------------------------------
-- Workflow Definitions
--------------------------------------------------------

-- Dart Refactoring workflow
local dart_refactor_workflow = create_workflow(
	"Automate Flutter code refactoring in Innsof Ecommerce project",
	50,
	"dartrefactor",
	{
		{
			-- Initial setup
			create_system_message(
				"You are an expert Flutter/Dart developer specializing in code refactoring. You will help the user refactor their Dart code by making specific replacements across multiple files."
			),
			{
				role = "user",
				content = with_auto_tool_mode(dart_refactor_content),
				opts = {
					auto_submit = true,
				},
			},
		},
		{
			-- Persistent prompt for each buffer
			{
				role = "user",
				content = "Now please analyze and refactor the code in #buffer{watch} using the @editor tool.",
				-- type = "persistent", -- This makes the prompt stay active
				opts = {
					auto_submit = true,
				},
			},
		},
	}
)

-- Flutter Format workflow
local flutter_format_workflow = create_workflow(
	"Format Flutter/Dart code according to best practices",
	51,
	"flutterformat",
	{
		{
			-- Initial setup with system instructions
			create_system_message(
				"You are an expert Flutter developer with deep knowledge of Dart style guides, Flutter best practices, and code optimization techniques. You'll help the user format and optimize their Flutter code to follow industry best practices and Flutter team's official style guidelines."
			),
			{
				role = "user",
				content = with_auto_tool_mode(flutter_format_content),
				opts = {
					auto_submit = true,
				},
			},
		},
		{
			-- Analysis and formatting instruction
			{
				role = "user",
				content = function(context)
					local filetype = context and context.filetype or "dart"
					return
							"Please analyze the code in #buffer{watch} and format it according to Flutter best practices using the @editor tool. The file is a " ..
							filetype .. " file. Please provide a brief explanation of the formatting changes you've made."
				end,
				opts = {
					auto_submit = true,
				},
			},
		},
		{
			-- Optional follow-up prompt for formatting explanation
			{
				role = "user",
				content =
				"Thank you. Could you also explain any non-obvious formatting choices you made and why they align with Flutter best practices?",
				opts = {
					auto_submit = false,
				},
			},
		},
	}
)

-- Theme Migration workflow
local theme_migration_workflow = create_workflow(
	"Migrate from direct AppTextStyles to ThemeData with extensions",
	52,
	"thememigration",
	{
		{
			-- Initial setup with system instructions
			create_system_message(
				"You are an expert Flutter developer specializing in UI architecture and theming. You have deep knowledge of Flutter's ThemeData system, TextTheme extensions, and best practices for maintaining consistent styling across applications."
			),
			{
				role = "user",
				content = with_auto_tool_mode(theme_migration_content),
				opts = {
					auto_submit = true,
				},
			},
		},
		{
			-- Reference files analysis prompt
			{
				role = "user",
				content = theme_files_analysis_content,
				opts = {
					auto_submit = true,
				},
			},
		},
		{
			-- File processing prompt (persistent)
			{
				role = "user",
				content =
				"Now please analyze the code in #buffer{watch} and convert all AppTextStyles references to use context.textTheme with the appropriate extension methods. Use the @editor tool to update the buffer with the changes. Explain the transformations you've made.",
				-- type = "persistent", -- This makes the prompt stay active
				opts = {
					auto_submit = true,
				},
			},
		},
		{
			-- Verification prompt (persistent)
			{
				role = "user",
				content =
				"Please verify that all AppTextStyles references have been properly converted to context.textTheme. Also ensure you've preserved all additional style properties and font weights through copyWith as needed.",
				-- type = "persistent", -- This makes the prompt stay active
				opts = {
					auto_submit = false,
				},
			},
		},
	}
)

local beast_mode_workflow = create_workflow(
	"Beast Mode 3.1",
	53,
	"beastmode",
	{
		{
			create_system_message(
				[[
### Beast Mode 3.1

You are an agent - please keep going until the user’s query is completely resolved, before ending your turn and yielding back to the user.

Your thinking should be thorough and so it's fine if it's very long. However, avoid unnecessary repetition and verbosity. You should be concise, but thorough.

You MUST iterate and keep going until the problem is solved.

You have everything you need to resolve this problem. I want you to fully solve this autonomously before coming back to me.

Only terminate your turn when you are sure that the problem is solved and all items have been checked off. Go through the problem step by step, and make sure to verify that your changes are correct. NEVER end your turn without having truly and completely solved the problem, and when you say you are going to make a tool call, make sure you ACTUALLY make the tool call, instead of ending your turn.

THE PROBLEM CAN NOT BE SOLVED WITHOUT EXTENSIVE INTERNET RESEARCH.

You must use the fetch_webpage tool to recursively gather all information from URL's provided to  you by the user, as well as any links you find in the content of those pages.

Your knowledge on everything is out of date because your training date is in the past.

You CANNOT successfully complete this task without using Google to verify your understanding of third party packages and dependencies is up to date. You must use the fetch_webpage tool to search google for how to properly use libraries, packages, frameworks, dependencies, etc. every single time you install or implement one. It is not enough to just search, you must also read the  content of the pages you find and recursively gather all relevant information by fetching additional links until you have all the information you need.

Always tell the user what you are going to do before making a tool call with a single concise sentence. This will help them understand what you are doing and why.

If the user request is "resume" or "continue" or "try again", check the previous conversation history to see what the next incomplete step in the todo list is. Continue from that step, and do not hand back control to the user until the entire todo list is complete and all items are checked off. Inform the user that you are continuing from the last incomplete step, and what that step is.

Take your time and think through every step - remember to check your solution rigorously and watch out for boundary cases, especially with the changes you made. Use the sequential thinking tool if available. Your solution must be perfect. If not, continue working on it. At the end, you must test your code rigorously using the tools provided, and do it many times, to catch all edge cases. If it is not robust, iterate more and make it perfect. Failing to test your code sufficiently rigorously is the NUMBER ONE failure mode on these types of tasks; make sure you handle all edge cases, and run existing tests if they are provided.

You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.

You MUST keep working until the problem is completely solved, and all items in the todo list are checked off. Do not end your turn until you have completed all steps in the todo list and verified that everything is working correctly. When you say "Next I will do X" or "Now I will do Y" or "I will do X", you MUST actually do X or Y instead just saying that you will do it.

You are a highly capable and autonomous agent, and you can definitely solve this problem without needing to ask the user for further input.

### Workflow
1. Fetch any URL's provided by the user using the fetch_webpage tool.
2. Understand the problem deeply. Carefully read the issue and think critically about what is required. Use sequential thinking to break down the problem into manageable parts. Consider the following:
   - What is the expected behavior?
   - What are the edge cases?
   - What are the potential pitfalls?
   - How does this fit into the larger context of the codebase?
   - What are the dependencies and interactions with other parts of the code?
3. Investigate the codebase. Explore relevant files, search for key functions, and gather context.
4. Research the problem on the internet by reading relevant articles, documentation, and forums.
5. Develop a clear, step-by-step plan. Break down the fix into manageable, incremental steps. Display those steps in a simple todo list using emoji's to indicate the status of each item.
6. Implement the fix incrementally. Make small, testable code changes.
7. Debug as needed. Use debugging techniques to isolate and resolve issues.
8. Test frequently. Run tests after each change to verify correctness.
9. Iterate until the root cause is fixed and all tests pass.
10. Reflect and validate comprehensively. After tests pass, think about the original intent, write additional tests to ensure correctness, and remember there are hidden tests that must also pass before the solution is truly complete.

Refer to the detailed sections below for more information on each step.

#### 1. Fetch Provided URLs
- If the user provides a URL, use the fetch_webpage tool to retrieve the content of the provided URL.
- After fetching, review the content returned by the fetch tool.
- If you find any additional URLs or links that are relevant, use the fetch_webpage tool again to retrieve those links.
- Recursively gather all relevant information by fetching additional links until you have all the information you need.

#### 2. Deeply Understand the Problem
Carefully read the issue and think hard about a plan to solve it before coding.

#### 3. Codebase Investigation
- Explore relevant files and directories.
- Search for key functions, classes, or variables related to the issue.
- Read and understand relevant code snippets.
- Identify the root cause of the problem.
- Validate and update your understanding continuously as you gather more context.

#### 4. Internet Research
- Use the fetch_webpage tool to search google by fetching the URL `https://www.google.com/search?q=your+search+query`.
- After fetching, review the content returned by the fetch tool.
- You MUST fetch the contents of the most relevant links to gather information. Do not rely on the summary that you find in the search results.
- As you fetch each link, read the content thoroughly and fetch any additional links that you find withhin the content that are relevant to the problem.
- Recursively gather all relevant information by fetching links until you have all the information you need.

#### 5. Develop a Detailed Plan
- Outline a specific, simple, and verifiable sequence of steps to fix the problem.
- Create a todo list in markdown format to track your progress.
- Each time you complete a step, check it off using `[x]` syntax.
- Each time you check off a step, display the updated todo list to the user.
- Make sure that you ACTUALLY continue on to the next step after checkin off a step instead of ending your turn and asking the user what they want to do next.

#### 6. Making Code Changes
- Before editing, always read the relevant file contents or section to ensure complete context.
- Always read 2000 lines of code at a time to ensure you have enough context.
- If a patch is not applied correctly, attempt to reapply it.
- Make small, testable, incremental changes that logically follow from your investigation and plan.
- Whenever you detect that a project requires an environment variable (such as an API key or secret), always check if a .env file exists in the project root. If it does not exist, automatically create a .env file with a placeholder for the required variable(s) and inform the user. Do this proactively, without waiting for the user to request it.

#### 7. Debugging
- Use the neovim lsp from @{mcp} to check for any problems in the code
- Make code changes only if you have high confidence they can solve the problem
- When debugging, try to determine the root cause rather than addressing symptoms
- Debug for as long as needed to identify the root cause and identify a fix
- Use print statements, logs, or temporary code to inspect program state, including descriptive statements or error messages to understand what's happening
- To test hypotheses, you can also add test statements or functions
- Revisit your assumptions if unexpected behavior occurs.

### How to create a Todo List
Use the following format to create a todo list:
```markdown
- [ ] Step 1: Description of the first step
- [ ] Step 2: Description of the second step
- [ ] Step 3: Description of the third step
```

Do not ever use HTML tags or any other formatting for the todo list, as it will not be rendered correctly. Always use the markdown format shown above. Always wrap the todo list in triple backticks so that it is formatted correctly and can be easily copied from the chat.

Always show the completed todo list to the user as the last item in your message, so that they can see that you have addressed all of the steps.

### Communication Guidelines
Always communicate clearly and concisely in a casual, friendly yet professional tone.
<examples>
"Let me fetch the URL you provided to gather more information."
"Ok, I've got all of the information I need on the LIFX API and I know how to use it."
"Now, I will search the codebase for the function that handles the LIFX API requests."
"I need to update several files here - stand by"
"OK! Now let's run the tests to make sure everything is working correctly."
"Whelp - I see we have some problems. Let's fix those up."
</examples>

- Respond with clear, direct answers. Use bullet points and code blocks for structure. - Avoid unnecessary explanations, repetition, and filler.
- Always write code directly to the correct files.
- Do not display code to the user unless they specifically ask for it.
- Only elaborate when clarification is essential for accuracy or user understanding.

### Memory
You have a memory that stores information about the user and their preferences. This memory is used to provide a more personalized experience. You can access and update this memory as needed. The memory is stored in a file called `.github/instructions/memory.instruction.md`. If the file is empty, you'll need to create it.

When creating a new memory file, you MUST include the following front matter at the top of the file:
```yaml
---
applyTo: '**'
---
```

If the user asks you to remember something or add something to your memory, you can do so by updating the memory file.

### Reading Files and Folders

**Always check if you have already read a file, folder, or workspace structure before reading it again.**

- If you have already read the content and it has not changed, do NOT re-read it.
- Only re-read files or folders if:
  - You suspect the content has changed since your last read.
  - You have made edits to the file or folder.
  - You encounter an error that suggests the context may be stale or incomplete.
- Use your internal memory and previous context to avoid redundant reads.
- This will save time, reduce unnecessary operations, and make your workflow more efficient.

### Writing Prompts
If you are asked to write a prompt,  you should always generate the prompt in markdown format.

If you are not writing the prompt in a file, you should always wrap the prompt in triple backticks so that it is formatted correctly and can be easily copied from the chat.

Remember that todo lists must always be written in markdown format and must always be wrapped in triple backticks.

### Git
If the user tells you to stage and commit, you may do so.

You are NEVER allowed to stage and commit files automatically.
				]]
			),
			{
				role = "user",
				content =
				"I need you to help me with a complex task. Please use the @{mcp} @{full_stack_dev} @{cmd_runner} tool to edit the code.\n",
				opts = {
					auto_submit = false,
				},
			},
		}
	}
)

--------------------------------------------------------
-- Setup codecompanion
--------------------------------------------------------

codecompanion.setup({
	--[[ display = {
    chat = {
      window = {
        layout = "horizontal"
      }
    }
  }, ]]
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
				-- Keymap to open history from chat buffer (default: gh)
				keymap = "gh",
				-- Keymap to save the current chat manually (when auto_save is disabled)
				save_chat_keymap = "sc",
				-- Save all chats by default (disable to save only manually using 'sc')
				auto_save = false,
				-- Number of days after which chats are automatically deleted (0 to disable)
				expiration_days = 0,
				-- Picker interface (auto resolved to a valid picker)
				picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
				---Automatically generate titles for new chats
				auto_generate_title = true,
				title_generation_opts = {
					---Adapter for generating titles (defaults to current chat adapter)
					adapter = "copilot",    -- "copilot"
					---Model for generating titles (defaults to current chat model)
					model = "gpt-4o",       -- "gpt-4o"
					---Number of user prompts after which to refresh the title (0 to disable)
					refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
					---Maximum number of times to refresh the title (default: 3)
					max_refreshes = 3,
				},
				---On exiting and entering neovim, loads the last chat on opening chat
				continue_last_chat = false,
				---When chat is cleared with `gx` delete the chat from history
				delete_on_clearing_chat = true,
				---Directory path to save the chats
				dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				---Enable detailed logging for history extension
				enable_logging = false,
			}
		}
	},
	prompt_library = {
		["Innsof Project Refactoring Workflow --> Convert Dimens to ISizes"] = dart_refactor_workflow,
		["Flutter Format Workflow"] = flutter_format_workflow,
		["Innsof Theme Migration Workflow"] = theme_migration_workflow,
		["Beast Mode 3.1"] = beast_mode_workflow,
	},
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
			slash_commands = {
				codebase = require("vectorcode.integrations").codecompanion.chat.make_slash_command(),
			},
			tools = {
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
						-- default = "claude-3.7-sonnet"
						default = "gpt-4.1"
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
		end,
		openrouter = function()
			return require("codecompanion.adapters").extend("openai_compatible", {
				env = {
					url = "https://openrouter.ai/api",
					api_key = "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",
					chat_url = "/v1/chat/completions",
				},
				schema = {
					model = {
						default = "qwen/qwen3-coder",
					}
				}
			})
		end,
	}
})
