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

--------------------------------------------------------
-- Setup codecompanion
--------------------------------------------------------

codecompanion.setup({
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        show_result_in_chat = true, -- Show mcp tool results in chat
        make_vars = true,           -- Convert resources to #variables
        make_slash_commands = true, -- Add prompts as /slash commands
      }
    },
    history = {
      enabled = true,
      opts = {
        -- Keymap to open history from chat buffer (default: gh)
        keymap = "gh",
        -- Automatically generate titles for new chats
        auto_generate_title = true,
        ---On exiting and entering neovim, loads the last chat on opening chat
        continue_last_chat = false,
        ---When chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = true,
        -- Picker interface ("telescope" or "snacks" or "default")
        picker = "snacks",
        ---Enable detailed logging for history extension
        enable_logging = true,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        -- Save all chats by default
        auto_save = true,
        -- Keymap to save the current chat manually
        save_chat_keymap = "sc",
      }
    }
  },
  prompt_library = {
    ["Innsof Project Refactoring Workflow --> Convert Dimens to ISizes"] = dart_refactor_workflow,
    ["Flutter Format Workflow"] = flutter_format_workflow,
    ["Innsof Theme Migration Workflow"] = theme_migration_workflow,
  },
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
      slash_commands = {
        codebase = require("vectorcode.integrations").codecompanion.chat.make_slash_command(),
      },
      tools = {
        opts = {
          auto_submit_errors = true,  -- Send any errors to the LLM automatically?
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
            default = "claude-sonnet-4"
          }
        }
      })
    end
  }
})
