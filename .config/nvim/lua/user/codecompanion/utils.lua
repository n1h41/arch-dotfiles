local M = {}

function M.create_system_message(content)
	return { role = "system", content = content, opts = { visible = false } }
end

function M.with_auto_tool_mode(content_fn)
	return function()
		vim.g.codecompanion_auto_tool_mode = true
		return content_fn()
	end
end

function M.create_workflow(description, index, short_name, prompts, is_default, tools)
	return {
		strategy = "workflow",
		description = description,
		opts = {
			--[[ default_tools = {
				"cmd_runner",        -- Execute shell commands and tests
				"create_file",       -- Create new files
				"file_search",       -- Find files by pattern
				"get_changed_files", -- Get git diffs of changes
				"grep_search",       -- Search text within files
				"insert_edit_into_file", -- Edit and modify files
				"list_code_usages",  -- Find code symbol usage
				"read_file",         -- Read file contents
				"fetch_webpage",     -- Fetch content from URLs
				"search_web"         -- Search the internet
			}, ]]
			index = index,
			is_default = is_default or true,
			short_name = short_name,
			auto_submit = true,
		},
		prompts = prompts,
	}
end

return M
