-- Modern LSP configuration using vim.lsp.config (nvim 0.11+)
-- This replaces the deprecated require('lspconfig') setup

-- Setup mason for automatic LSP server installation
local mason_status, mason = pcall(require, "mason")
if mason_status then
	mason.setup()
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_status then
	mason_lspconfig.setup({
		ensure_installed = { 'lua_ls', "gopls", "html", "emmet_language_server", "tailwindcss", "htmx", "templ" }
	})
end
local cmp = require('cmp')

-- LSP completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.colorProvider = {
	dynamicRegistration = true
}

-- Templ format function
local templ_format = function()
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
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Basic LSP navigation (some will be overridden by glance.nvim)
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

	-- Workspace management
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)

	-- Type definition (will be overridden by glance)
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)

	-- Format buffer
	local format_opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "<S-A-f>", templ_format, format_opts)

	-- Document highlight - highlight references under cursor
	if client.server_capabilities.documentHighlightProvider then
		local highlight_group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			group = highlight_group,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = highlight_group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

-- Configure LSP servers using vim.lsp.config
vim.lsp.config.lua_ls = {
	on_attach = on_attach,
	capabilities = capabilities,
	on_init = function(client)
		if not client.workspace_folders or #client.workspace_folders == 0 then
			return
		end

		local path = client.workspace_folders[1].name
		if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
			runtime = {
				version = 'LuaJIT'
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
				}
			}
		})
	end,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			}
		}
	}
}

vim.lsp.config.gopls = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = vim.fs.root(0, { "go.mod", ".git" }),
}

vim.lsp.config.html = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "templ" },
}

vim.lsp.config.htmx = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "templ" },
}

vim.lsp.config.tailwindcss = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "typescriptreact", "typescript.tsx", "templ" },
	settings = {
		tailwindCSS = {
			includeLanguages = {
				templ = "html",
			}
		}
	}
}

vim.lsp.config.clangd = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "c", "cpp", "objc", "objcpp", "h" },
	cmd = { "/home/n1h41/tools/esp-clang/bin/clangd", "--background-index", "--query-driver=**", "--offset-encoding=utf-16" },
}

vim.lsp.config.qmlls = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "qml" },
}

vim.lsp.config.omnisharp = {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
}

-- Setup CMP with protocol icons
local protocol = require('vim.lsp.protocol')

protocol.CompletionItemKind = {
	'', -- Text
	'󰊕', -- Method
	'󰊕', -- Function
	'󰊕', -- Constructor
	'', -- Field
	'', -- Variable
	'', -- Class
	'󰜰', -- Interface
	'󰏗', -- Module
	'', -- Property
	'', -- Unit
	'󰎠', -- Value
	'', -- Enum
	'', -- Keyword
	'󰘍', -- Snippet
	'', -- Color
	'', -- File
	'󰆑', -- Reference
	'', -- Folder
	'', -- EnumMember
	'', -- Constant
	'', -- Struct
	'', -- Event
	'ﬦ', -- Operator
	'', -- TypeParameter
}

local lspkind = require('lspkind')

-- CMP setup
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-y>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({
			select = false
		})
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
		{ name = 'lazydev', group_index = 0 },
	}, {
		{ name = 'buffer',               keyword_length = 5 },
		{ name = 'cmp-dbee' },
		{ name = 'vim-dadbod-completion' },
	}),
	formatting = {
		fields = { 'abbr', 'kind', 'menu' },
		format = lspkind.cmp_format({
			mode = 'symbol_text',
			maxwidth = 50,
			ellipsis_char = '...',
			before = function(_, vim_item)
				vim_item.kind = string.format('%s %s', lspkind.presets.default[vim_item.kind], vim_item.kind)
				vim_item.menu = ""
				return vim_item
			end
		})
	},
})

-- CMP autopairs integration
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Templ file auto-format
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.templ" },
	callback = templ_format
})

-- Diagnostic configuration using modern vim.diagnostic.config (nvim 0.11+)
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙", -- Error icon
			[vim.diagnostic.severity.WARN] = "", -- Warning icon
			[vim.diagnostic.severity.HINT] = "󰌵", -- Hint icon
			[vim.diagnostic.severity.INFO] = "󰋼", -- Info icon
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Flutter tools setup
local flutter = require('flutter-tools')

flutter.setup {
	ui = {
		border = "rounded",
		notification_style = 'plugin'
	},
	decorations = {
		statusline = {
			app_version = true,
			device = true,
			project_config = true,
		}
	},

	debugger = {
		enabled = true,
		run_via_dap = true,
		exception_breakpoints = { "uncaught" }
	},
	flutter_path = "/home/n1h41/development/flutter/bin/flutter",
	fvm = false,
	default_run_args = {
		flutter = "--print-dtd"
	},
	widget_guides = {
		enabled = true,
	},
	dev_log = {
		enabled = true,
		notify_errors = false,
		open_cmd = "tabnew",
	},
	dev_tools = {
		autostart = true,
		auto_open_browser = false,
	},
	outline = {
		open_cmd = "50vnew",
		auto_open = false
	},
	lsp = {
		color = {
			enabled = true,
			background = true,
			foreground = true,
			virtual_text = true,
			virtual_text_str = "■",
		},
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			showTodos = false,
			completeFunctionCalls = true,
			analysisExcludedFolders = {
				"/home/n1h41/.pub-cache/hosted/",
				"/home/n1h41/flutter/",
			},
			renameFilesWithClasses = "prompt",
			enableSnippets = true,
			updateImportsOnRename = true,
		}
	}
}
