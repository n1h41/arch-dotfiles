-- Centralized colorscheme selection and configuration.
--
-- Only ONE theme should be active at a time. To switch themes:
--   1. Change `active_theme` below.
--   2. Ensure the corresponding plugin is installed (see lua/user/plugin.lua).
--
-- Each theme's dedicated configuration lives in its own function below.
-- Themes are loaded lazily (the require() only runs when selected).

local M = {}

-- The currently active theme. Change this to switch colorschemes.
-- Available: "kanso", "catppuccin", "cyberdream", "onedark", "vscode", "neosolarized"
local active_theme = "kanso"

-- Kanso (https://github.com/alpha2phi/kanso.nvim)
local function setup_kanso()
	local status, kanso = pcall(require, "kanso")
	if not status then return end

	kanso.setup({
		compile = false,  -- enable compiling the colorscheme
		undercurl = true, -- enable undercurls
		commentStyle = { italic = true },
		functionStyle = {},
		keywordStyle = { italic = true },
		statementStyle = {},
		typeStyle = {},
		disableItalics = false,
		transparent = true,   -- do not set background color
		dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
		terminalColors = true, -- define vim.g.terminal_color_{0,17}
		colors = {             -- add/modify theme and palette colors
			palette = {},
			theme = { zen = {}, pearl = {}, ink = {}, all = {} },
		},
		overrides = function() -- add/modify highlights
			return {}
		end,
		theme = "zen",  -- Load "zen" theme
		background = {  -- map the value of 'background' option to a theme
			dark = "zen", -- try "ink" !
			light = "pearl"
		},
	})

	-- setup must be called before loading
	vim.cmd("colorscheme kanso-zen")
end

-- Catppuccin (https://github.com/catppuccin/nvim)
local function setup_catppuccin()
	local status, catppuccin = pcall(require, "catppuccin")
	if not status then return end

	catppuccin.setup({
		flavour = 'mocha',
		term_colors = true,
		transparent_background = false,
		styles = {
			comments = {}, conditionals = {}, loops = {}, functions = {},
			keywords = {}, strings = {}, variables = {}, numbers = {},
			booleans = {}, properties = {}, types = {},
		},
		color_overrides = {
			mocha = {
				base = "#000000", mantle = "#000000", crust = "#000000",
			},
		},
		integrations = {
			telescope = { enabled = true, style = "nvchad" },
			dropbar = { enabled = true, color_mode = true },
		},
	})

	vim.cmd.colorscheme("catppuccin")
end

-- Cyberdream (https://github.com/scottmckendry/cyberdream.nvim)
local function setup_cyberdream()
	local status, cyberdream = pcall(require, "cyberdream")
	if not status then return end

	cyberdream.setup({
		transparent = false,
		italic_comments = true,
		hide_fillchars = true,
	})

	vim.cmd.colorscheme("cyberdream")
end

-- OneDark (https://github.com/navarasu/onedark.nvim)
local function setup_onedark()
	local status, onedark = pcall(require, "onedark")
	if not status then return end

	onedark.setup({
		style = "deep",
		transparent = false,
		toggle_style_key = "<leader>ts",
		code_style = {
			keywords = 'bold',
			strings = 'none',
			variables = 'none',
		},
		highlights = {
			["DashboardHeader"] = { fg = "#FF4500" },
			["DashboardFooter"] = { fg = "#e3e3e3" },
			["DashboardShortCut"] = { fg = "white" },
			["NormalFloat"] = { bg = "NONE" },
			["HoverBorder"] = { bg = "NONE" },
			["SagaBorder"] = { bg = "NONE" },
			["FloatBorder"] = { bg = "NONE", fg = "#8BCD5B" },
			["Pmenu"] = { bg = "NONE" },
			["PmenuSel"] = { fg = "#e3e3e3" },
			["PmenuSbar"] = { bg = "#1A212E" },
			["PmenuThumb"] = { bg = "#8BCD5B" },
			["BorderBg"] = { bg = "#8BCD5B" },
		},
	})

	onedark.load()
end

-- VSCode (https://github.com/Mofiqul/vscode.nvim)
local function setup_vscode()
	local status = pcall(require, "vscode")
	if not status then return end

	local c = require('vscode.colors').get_colors()
	require('vscode').setup({
		transparent = false,
		italic_comments = true,
		disable_nvimtree_bg = true,
		color_overrides = {
			vscLineNumber = '#707070',
		},
		group_overrides = {
			Cursor = { fg = c.vscDarkBlue, bg = c.vscGreen, bold = true },
		},
	})

	require('vscode').load()
end

-- NeoSolarized (https://github.com/overcache/NeoSolarized)
local function setup_neosolarized()
	local status = pcall(require, "neosolarized")
	if not status then return end

	require("neosolarized").setup({ comment_italics = true })
	vim.cmd.colorscheme("neosolarized")
end

-- Map theme name -> setup function
local themes = {
	kanso = setup_kanso,
	catppuccin = setup_catppuccin,
	cyberdream = setup_cyberdream,
	onedark = setup_onedark,
	vscode = setup_vscode,
	neosolarized = setup_neosolarized,
}

-- Load the active theme.
function M.load()
	local theme = themes[active_theme]
	if not theme then
		vim.notify('Unknown theme: ' .. tostring(active_theme), vim.log.levels.ERROR)
		return
	end
	theme()
end

-- Expose for potential dynamic switching.
M.active_theme = active_theme

return M
