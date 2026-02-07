local status, wk = pcall(require, "which-key")
if (not status) then
	return
end

local status2, telescope = pcall(require, "telescope.builtin")
if (not status2) then
	return
end

-- Setup which-key mappings for Telescope
wk.add({
	-- File operations
	{ "<leader>ht", function() telescope.help_tags() end,                                      desc = "List help tags", mode = "n" },
	{ "<leader>ff", function() telescope.find_files({ no_ignore = false, hidden = true }) end, desc = "Find files",     mode = "n" },
	{ "<leader>fr", function() telescope.live_grep({ no_ignore = false, hidden = true }) end,  desc = "Live Grep",      mode = "n" },
	{ "<leader>aC", function() telescope.commands() end,                                       desc = "List commands",  mode = "n" },

	-- LSP operations
	{ "<leader>ls", function() telescope.lsp_document_symbols() end,                           desc = "Document Symbols",    mode = "n" },
	{ "<leader>lw", function() telescope.lsp_dynamic_workspace_symbols() end,                  desc = "Workspace Symbols",   mode = "n" },
	{ "<leader>lr", function() telescope.lsp_references() end,                                 desc = "LSP References",      mode = "n" },
	{ "<leader>li", function() telescope.lsp_implementations() end,                            desc = "LSP Implementations", mode = "n" },
	{ "<leader>ld", function() telescope.lsp_definitions() end,                                desc = "LSP Definitions",     mode = "n" },
	{ "<leader>lt", function() telescope.lsp_type_definitions() end,                           desc = "Type Definitions",    mode = "n" },

	-- Diagnostic operations (complement to built-in diagnostics)
	{ "<leader>ds", function() telescope.diagnostics({ bufnr = 0 }) end,                       desc = "Buffer Diagnostics",  mode = "n" },
	{ "<leader>dw", function() telescope.diagnostics() end,                                    desc = "Workspace Diagnostics", mode = "n" },
}, {
	silent = true, -- Don't echo commands
	noremap = true, -- Non-recursive mapping
	nowait = false, -- Wait for additional keypresses
	buffer = nil,  -- Apply to all buffers
})
