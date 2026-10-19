-- Diagnostic configuration and LSP patches.
-- Uses modern vim.diagnostic.config (nvim 0.11+).

-- Diagnostic configuration
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙", -- Error icon
			[vim.diagnostic.severity.WARN] = "",    -- Warning icon
			[vim.diagnostic.severity.HINT] = "󰌵", -- Hint icon
			[vim.diagnostic.severity.INFO] = "󰋼", -- Info icon
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Suppress yamlls "Matches multiple schemas" false positive (core k8s resources
-- with apiVersion: v1 fall back to the all.json schema and warn spuriously)
local on_publish_diagnostics = vim.lsp.diagnostic.on_publish_diagnostics
vim.lsp.diagnostic.on_publish_diagnostics = function(_, result, ctx, config)
	if result and result.diagnostics then
		result.diagnostics = vim.tbl_filter(function(d)
			return not (d.source and d.source:find('^yaml%-schema:') and d.message:find('Matches multiple schemas'))
		end, result.diagnostics)
	end
	return on_publish_diagnostics(_, result, ctx, config)
end

-- Patch nvim_win_set_cursor to clamp out-of-bounds positions (prevents LSP-induced E315)
local original_set_cursor = vim.api.nvim_win_set_cursor
vim.api.nvim_win_set_cursor = function(win, pos)
	if type(pos) ~= "table" or pos[1] == nil then
		return
	end
	local ok, err = pcall(function()
		local buf = vim.api.nvim_win_get_buf(win)
		local line_count = vim.api.nvim_buf_line_count(buf)
		local line = math.min(pos[1], line_count)
		local col = pos[2] or 0
		original_set_cursor(win, { line, col })
	end)
	if not ok then
		vim.notify('Cursor position error (suppressed): ' .. tostring(err), vim.log.levels.DEBUG)
	end
end
