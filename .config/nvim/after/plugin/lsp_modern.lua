-- Modern LSP configuration using vim.lsp.config (nvim 0.11+)
-- This replaces the deprecated lspconfig framework

-- Check if vim.lsp.config is available (Neovim 0.11+)
if not vim.lsp.config then
	-- Fallback to old configuration for older Neovim versions
	return
end

local cmp = require('cmp')

-- LSP completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.colorProvider = {
	dynamicRegistration = true
}

-- LSP on_attach function
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	-- Mappings
	local opts = { noremap = true, silent = true }

	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

	-- Format function for templ files
	local templ_format = function()
		if vim.bo.filetype == "templ" then
			local bufnr_local = vim.api.nvim_get_current_buf()
			local filename = vim.api.nvim_buf_get_name(bufnr_local)
			local cmd = "templ fmt " .. vim.fn.shellescape(filename)

			vim.fn.jobstart(cmd, {
				on_exit = function()
					if vim.api.nvim_get_current_buf() == bufnr_local then
						vim.cmd('e!')
					end
				end,
			})
		else
			vim.lsp.buf.format()
		end
	end

	local format_opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "<S-A-f>", templ_format, format_opts)
end

-- Configure LSP servers using vim.lsp.config
vim.lsp.config.lua_ls = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	on_attach = on_attach,
	capabilities = capabilities,
	on_init = function(client)
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
		Lua = {}
	}
}

vim.lsp.config.gopls = {
	cmd = { 'gopls' },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	on_attach = on_attach,
	capabilities = capabilities,
	root_markers = { "go.mod", ".git" },
}

vim.lsp.config.html = {
	cmd = { 'vscode-html-language-server', '--stdio' },
	filetypes = { "html", "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
}

vim.lsp.config.htmx = {
	cmd = { 'htmx-lsp' },
	filetypes = { "html", "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
}

vim.lsp.config.tailwindcss = {
	cmd = { 'tailwindcss-language-server', '--stdio' },
	filetypes = { "html", "typescriptreact", "typescript.tsx", "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		tailwindCSS = {
			includeLanguages = {
				templ = "html",
			}
		}
	}
}

vim.lsp.config.clangd = {
	cmd = { "/home/n1h41/tools/esp-clang/bin/clangd", "--background-index", "--query-driver=**", "--offset-encoding=utf-16" },
	filetypes = { "c", "cpp", "objc", "objcpp", "h" },
	on_attach = on_attach,
	capabilities = capabilities,
}

vim.lsp.config.qmlls = {
	cmd = { 'qmlls' },
	filetypes = { "qml" },
	on_attach = on_attach,
	capabilities = capabilities,
}

vim.lsp.config.omnisharp = {
	cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
	on_attach = on_attach,
	capabilities = capabilities,
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
	mapping = {
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-y>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({
			select = false
		})
	},
	sources = {
		{
			name = 'nvim_lsp'
		},
		{
			name = 'path'
		},
		{
			name = 'luasnip'
		},
		{
			name = 'cmp-dbee'
		},
		{
			name = 'buffer',
			keyword_length = 5
		},
		{
			name = 'vim-dadbod-completion',
		},
		{
			name = 'lazydev',
			group_index = 0,
		},
	},
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
	callback = function()
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
		end
	end
})

-- Diagnostic configuration
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
})

-- Flutter tools setup (still uses old API for now)
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
			enabled = false,
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