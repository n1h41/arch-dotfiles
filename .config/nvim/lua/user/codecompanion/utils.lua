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

function M.create_workflow(description, index, short_name, prompts, is_default)
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

return M
