-- nvim-cmp completion configuration.
-- Handles completion sources, window borders, and formatting.

local cmp = require('cmp')

-- Setup CMP with protocol icons
local protocol = require('vim.lsp.protocol')

protocol.CompletionItemKind = {
	'',    -- Text
	'󰊕',  -- Method
	'󰊕',  -- Function
	'󰊕',  -- Constructor
	'',    -- Field
	'',    -- Variable
	'',    -- Class
	'󰜰',  -- Interface
	'󰏗',  -- Module
	'',    -- Property
	'',    -- Unit
	'󰎠',  -- Value
	'',    -- Enum
	'',    -- Keyword
	'󰘍',  -- Snippet
	'',    -- Color
	'',    -- File
	'󰆑',  -- Reference
	'',    -- Folder
	'',    -- EnumMember
	'',    -- Constant
	'',    -- Struct
	'',    -- Event
	'ﬦ',   -- Operator
	'',    -- TypeParameter
}

local lspkind = require('lspkind')

-- CMP setup
local cmp_mappings = cmp.mapping.preset.insert({
	["<C-b>"] = cmp.mapping.scroll_docs(-4),
	["<C-f>"] = cmp.mapping.scroll_docs(4),
	["<C-Space>"] = cmp.mapping.complete(),
	["<C-e>"] = cmp.mapping.abort(),
	["<CR>"] = cmp.mapping.confirm({
		select = false
	})
})

-- INFO: disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
	mapping = cmp_mappings,
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
	window = {
		completion = cmp.config.window.bordered({
			border = 'rounded',
			winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
		}),
		documentation = cmp.config.window.bordered({
			border = 'rounded',
			winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
		}),
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
local lsp = require("user.lsp")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.templ" },
	callback = lsp.templ_format
})
