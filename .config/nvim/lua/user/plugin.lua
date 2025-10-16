---@diagnostic disable: undefined-doc-name
-- Plugin specification and setup using lazy.nvim
-- This file lists all plugins, their lazy-loading triggers, dependencies, and custom configuration.
-- Plugins are managed via lazy.nvim for optimal performance and modularity.

---@diagnostic disable: missing-fields, undefined-field
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not installed
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
		lazypath })
end

vim.opt.rtp:prepend(lazypath)

-- Plugin list
local plugins = {
	rocks = {
		hererocks = true
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta",             lazy = true }, -- optional `vim.uv` typings,
	-- LSP
	-- LSP Support
	{ 'neovim/nvim-lspconfig' },
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{
		'dnlhc/glance.nvim',
		config = function()
			require('glance').setup()
		end,
	},                                    -- Modern LSP UI replacement for lspsaga
	{ 'onsails/lspkind-nvim' },           -- vscode like pictograms
	{ 'jose-elias-alvarez/null-ls.nvim' }, -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{
				"MattiasMTS/cmp-dbee",
				dependencies = {
					{ "kndndrj/nvim-dbee" }
				},
				ft = "sql", -- optional but good to have
				opts = {}, -- needed
			},
		},
	},
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'saadparwaiz1/cmp_luasnip' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-nvim-lua' },
	-- Snippets
	{ 'L3MON4D3/LuaSnip' },
	{ 'rafamadriz/friendly-snippets' },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},
	"nvim-treesitter/nvim-treesitter-context",
	-- Nice to haves
	{
		"numToStr/Comment.nvim",
		config = function()
			require('Comment').setup({
				opleader = {
					block = "<S-A-a>"
				}
			})
		end
	},
	{
		'stevearc/dressing.nvim',
	},
	{
		enabled = true,
		"github/copilot.vim",
	},
	"j-hui/fidget.nvim",
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true,   -- show icons in the signs column
			sign_priority = 8, -- sign priority
			-- keywords recognized as todo comments
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = "󱜾 ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
			gui_style = {
				fg = "NONE",                 -- The gui style to use for the fg highlight group.
				bg = "BOLD",                 -- The gui style to use for the bg highlight group.
			},
			merge_keywords = true,         -- when true, custom keywords will be merged with the defaults
			highlight = {
				multiline = true,            -- enable multine todo comments
				multiline_pattern = "^.",    -- lua pattern to match the next multiline from the start of the matched keyword
				multiline_context = 10,      -- extra lines that will be re-evaluated when changing a line
				before = "",                 -- "fg" or "bg" or empty
				keyword = "wide",            -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
				after = "fg",                -- "fg" or "bg" or empty
				pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
				comments_only = true,        -- uses treesitter to match keywords in comments only
				max_line_len = 400,          -- ignore lines longer than this
				exclude = {},                -- list of file types to exclude highlighting
			},
			colors = {
				error = { "#DC2626" },
				warning = { "#FBBF24" },
				info = { "#2563EB" },
				hint = { "#10B981" },
				default = { "#7C3AED" },
				test = { "#FF00FF" }
			},
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				pattern = [[\b(KEYWORDS):]], -- ripgrep regex
			},
		}
	},
	-- Git
	{
		"tpope/vim-fugitive",
		lazy = true,
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		lazy = true,
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {}
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
	},
	-- Statusline
	"nvim-lualine/lualine.nvim",
	-- Buffer
	"akinsho/nvim-bufferline.lua",
	-- Toggleterm
	{
		'akinsho/toggleterm.nvim',
		lazy = true,
		version = "*",
		config = function()
			require("toggleterm").setup(
				{
					size = 10,
					open_mapping = [[<C-\>]],
					hide_numbers = true,
					shade_filetypes = {},
					shade_terminals = true,
					shading_factor = 2,
					start_in_insert = true,
					insert_mappings = true,
					persist_size = true,
					close_on_exit = true,
					direction = 'float',
					float_opts = {
						border = "curved",
						winblend = 0,
						highlights = {
							border = "Normal",
							background = "Normal"
						}
					}
				}
			)
		end,
	},
	-- Autopairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	-- Highlight Color Codes
	{
		'NvChad/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup({
				filetypes = { "*" },
				user_default_options = {
					RGB = true,
					RRGGBB = true,
					names = true,
					RRGGBBAA = true,
					AARRGGBB = true,
					rgb_fn = false,
					hsl_fn = false,
					css = false,
					css_fn = false,
					mode = "background",
					tailwind = false,
					sass = { enable = false, parsers = { "css" } },
					virtualtext = "■",
				},
				buftypes = {},
			})
		end,
	},
	-- Debugger
	{
		lazy = true,
		'mfussenegger/nvim-dap',
		dependencies = {
			"jbyuki/one-small-step-for-vimkind",
			'nvim-telescope/telescope-dap.nvim',
			'rcarriga/nvim-dap-ui',
			{ "mxsdev/nvim-dap-vscode-js", module = { "dap-vscode-js" } },
			{
				"microsoft/vscode-node-debug2",
				opt = true,
				run = "npm install && npm run build"

			},
			{
				'theHamsta/nvim-dap-virtual-text',
				config = function()
					require('nvim-dap-virtual-text').setup({})
				end
			}
		},
	},
	-- Which key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},
	-- Dashboard
	-- Flutter
	{
		'akinsho/flutter-tools.nvim',
		ft = { 'dart', 'flutter' },
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
	},                         -- Flutter Snippets
	"RobertBrunhage/flutter-riverpod-snippets",
	"Neevash/awesome-flutter-snippets",
	-- Golang Debugger
	{
		"leoluz/nvim-dap-go",
		config = function()
			require('dap-go').setup({
				dap_configurations = {
					{
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
			})
		end
	},
	-- Database Management
	--[[ {
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
	}, ]]
	{
		'navarasu/onedark.nvim'
	},
	-- Lua
	{
		"folke/zen-mode.nvim",
		opts = {
		}
	},
	-- PGSQL
	{ 'lifepillar/pgsql.vim' },
	-- Trouble
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},
	-- Golang extras
	-- Neotest
	{
		cmd = { "Neotest", "NeotestRun", "NeotestSummary" },
		"nvim-neotest/neotest",
		dependencies = { "nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			'sidlatau/neotest-dart',
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-plenary",
		}
	},
	-- DiffView
	{
		lazy = true,
		"sindrets/diffview.nvim",
		event = "BufRead",
	},
	--- Undotree
	{
		"mbbill/undotree",
	},
	{
		"ziontee113/color-picker.nvim",
	},
	--[[ {
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here
			-- vim.g.vimtex_view_method = "zathura"
		end
	}, ]]
	{ "nvim-neotest/nvim-nio" },
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			-- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- other stuff
			background_colour = "#333333"
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		}
	},
	{
		"folke/snacks.nvim",
	},
	-- Git integration (fugitive alternative)
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
			-- "ibhagwan/fzf-lua",            -- optional
		},
		config = true
	},
	--[[ {
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			ui = {
				enable = false,
			},
			workspaces = {
				{
					name = "personal",
					path = "/home/n1h41/Documents/obsidian-vault/",
				},
			},

			-- see below for full list of options 👇
		},
	}, ]]
	{
		-- lazy = true,
		'MeanderingProgrammer/render-markdown.nvim',
		opts = { latex = { enabled = false } },
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	},
	--[[ {
		"rest-nvim/rest.nvim",
	}, ]]
	{
		"kndndrj/nvim-dbee",
		branch = "master",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			-- Install tries to automatically detect the install method.
			-- if it fails, try calling it with one of these parameters:
			--    "curl", "wget", "bitsadmin", "go"
			require("dbee").install()
		end,
		config = function()
			require("dbee").setup( --[[optional config]])
		end,
	},
	{
		'anurag3301/nvim-platformio.lua',
		requires = {
			{ 'akinsho/nvim-toggleterm.lua' },
			{ 'nvim-telescope/telescope.nvim' },
			{ 'nvim-lua/plenary.nvim' },
		}
	},
	{
		"ranjithshegde/ccls.nvim",
	},
	{
		"olimorris/codecompanion.nvim",
		branch = "main",
		cmd = { "CodeCompanion" },
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/codecompanion-history.nvim"
		},
		init = function()
			require("user.lualine.codecompanion_fidget_spinner"):init()
		end
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		-- comment the following line to ensure hub will be ready at the earliest
		cmd = "MCPHub",                        -- lazy load by default
		build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
		-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
		-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
		--[[ config = function()
      require("mcphub").setup()
    end, ]]
	},
	{
		'stevearc/oil.nvim',
		cmd = { 'Oil' },
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
	}, -- Using Lazy
	{
		"webhooked/kanso.nvim",
		cmd = { "Kanso" },
		priority = 1000,
	},
	{
		'nvim-telescope/telescope-project.nvim',
		dependencies = {
			'nvim-telescope/telescope.nvim',
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		'echasnovski/mini.nvim',
		version = '*',
		config = function()
			require("mini.ai").setup()
		end
	},
	{
		'stevearc/conform.nvim',
		opts = {},
	},
	{
		'NickvanDyke/opencode.nvim',
		dependencies = {
			-- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
			{ 'folke/snacks.nvim' --[[ , opts = { input = { enabled = true } } ]] },
		},
		config = function()
			-- `opencode.nvim` passes options via a global variable instead of `setup()` for faster startup
			---@type opencode.Opts
			vim.g.opencode_opts = {
				prompts = {
					flutter_format = {
						description = "Format Flutter code",
						prompt = [[
### Flutter Code Formatting

Please help me format my Flutter code at @buffer according to best practices. When formatting the code, please:

#### Follow the official Dart Style Guide
1. Apply Flutter-specific formatting conventions:
   - Use proper widget structure with consistent indentation.
   - Format widget trees for readability (one widget per line for complex widgets).
   - Properly align parameters and trailing commas for enhanced readability.
   - Extract repeated widgets into reusable variables or methods.
   - Use const constructors where appropriate.
   - Format string interpolation consistently.
   - Apply proper spacing around operators, brackets, and parentheses.
   - Organize import statements according to best practices.
   - Add proper documentation for public APIs.

2. WITHOUT changing any functional behavior, improve code:
   - Remove redundant code.
   - Fix any style issues.
   - Improve naming if unclear.
   - Simplify complex expressions.
   - Apply proper nullable handling practices.
	 - Extract long inline methods to separate methods to improve readability.
			]],
					},
				}
			}

			-- Required for `opts.auto_reload`
			vim.opt.autoread = true

			-- Recommended keymaps
			vim.keymap.set('n', '<leader>ot', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
			vim.keymap.set('n', '<leader>oa', function() require('opencode').ask() end, { desc = 'Ask opencode' })
			vim.keymap.set('n', '<leader>oA', function() require('opencode').ask('@cursor: ') end,
				{ desc = 'Ask opencode about this' })
			vim.keymap.set('v', '<leader>oa', function() require('opencode').ask('@selection: ') end,
				{ desc = 'Ask opencode about selection' })
			vim.keymap.set('n', '<leader>on', function() require('opencode').command('session_new') end,
				{ desc = 'New opencode session' })
			vim.keymap.set('n', '<leader>oy', function() require('opencode').command('messages_copy') end,
				{ desc = 'Copy last opencode response' })
			vim.keymap.set('n', '<S-C-u>', function() require('opencode').command('messages_half_page_up') end,
				{ desc = 'Messages half page up' })
			vim.keymap.set('n', '<S-C-d>', function() require('opencode').command('messages_half_page_down') end,
				{ desc = 'Messages half page down' })
			vim.keymap.set({ 'n', 'v' }, '<leader>os', function() require('opencode').select() end,
				{ desc = 'Select opencode prompt' })

			-- Example: keymap for custom prompt
			vim.keymap.set('n', '<leader>oe', function() require('opencode').prompt('Explain @cursor and its context') end,
				{ desc = 'Explain this code' })
		end,
	},
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
	{
		"greggh/claude-code.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for git operations
		},
		config = function()
			require("claude-code").setup()
		end
	},
	-- LOCAL PLUGIN DEVELOPMENT
	{
		dir = "/home/nihal/dev/nvim/personal/speech_to_text/"
	},
	--[[ {
		dir = "/home/n1h41/dev/nvim/personal/n1h41-nvim/",
		config = function()
			require("n1h41").setup()
		end
	}, ]]
}

local ok, lazy = pcall(require, 'lazy')
if not ok then
	vim.notify('Error loading lazy.nvim: ' .. tostring(lazy), vim.log.levels.ERROR)
else
	lazy.setup(plugins, {})
end
