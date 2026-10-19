-- LSP shared setup: mason, shared helpers, and capabilities.
-- Server definitions live in servers.lua; completion in cmp.lua; diagnostics in diagnostics.lua.

local M = {}

-- Setup mason for automatic LSP server installation
local mason_status, mason = pcall(require, "mason")
if mason_status then
	mason.setup()
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_status then
	mason_lspconfig.setup({
		ensure_installed = {
			'lua_ls', 'gopls', 'html', 'emmet_language_server',
			'tailwindcss', 'templ', 'yamlls',
			-- DevOps
			'helm_ls', 'bashls', 'dockerls',
			'docker_compose_language_service', 'terraformls', 'ansiblels',
		},
	})
end

-- LSP completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.colorProvider = {
	dynamicRegistration = true
}

M.capabilities = capabilities

-- Templ format function
M.templ_format = function()
	if vim.bo.filetype == "templ" then
		local bufnr = vim.api.nvim_get_current_buf()
		local filename = vim.api.nvim_buf_get_name(bufnr)
		local cmd = "templ fmt " .. vim.fn.shellescape(filename)

		vim.fn.jobstart(cmd, {
			on_exit = function()
				if vim.api.nvim_get_current_buf() == bufnr then
					vim.cmd('e!')
				end
			end,
		})
	else
		vim.lsp.buf.format()
	end
end

-- LSP on_attach function
M.on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

	-- Mappings
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Basic LSP navigation
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

	-- Workspace management
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)

	-- Type definition
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)

	-- Format buffer
	local format_opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "<S-A-f>", M.templ_format, format_opts)

	-- Document highlight - highlight references under cursor
	if client.server_capabilities.documentHighlightProvider then
		local highlight_group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			group = highlight_group,
			buffer = bufnr,
			callback = function()
				-- Re-check capability at runtime (handles LspRestart edge cases)
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				for _, c in ipairs(clients) do
					if c.server_capabilities.documentHighlightProvider then
						vim.lsp.buf.document_highlight()
						return
					end
				end
			end,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = highlight_group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

return M
