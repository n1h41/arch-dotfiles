local M = {}

local function current_indent()
	return vim.fn.indent(vim.fn.line("."))
end

function M.goto_next_same_indent()
	local target = current_indent()
	local total = vim.fn.line("$")
	local lnum = vim.fn.line(".") + 1
	while lnum <= total do
		if vim.fn.getline(lnum):match("%S") and vim.fn.indent(lnum) == target then
			vim.api.nvim_win_set_cursor(0, { lnum, 0 })
			return
		end
		lnum = lnum + 1
	end
end

function M.goto_prev_same_indent()
	local target = current_indent()
	local lnum = vim.fn.line(".") - 1
	while lnum >= 1 do
		if vim.fn.getline(lnum):match("%S") and vim.fn.indent(lnum) == target then
			vim.api.nvim_win_set_cursor(0, { lnum, 0 })
			return
		end
		lnum = lnum - 1
	end
end

return M
