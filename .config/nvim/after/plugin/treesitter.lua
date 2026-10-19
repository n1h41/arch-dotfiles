-- local status, ts = pcall(require, "nvim-treesitter.configs")
-- if (not status) then return end

---@diagnostic disable-next-line: missing-fields
--[[ ts.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {
      "dart",
    },
  },
  ensure_installed = {
    "markdown",
    "markdown_inline",
    "tsx",
    "javascript",
    "typescript",
    "toml",
    "json",
    "yaml",
    "lua",
    "go",
    "html",
    "css",
    "c_sharp",
    "http",
    "json",
    "rust",
    "c",
    "cpp",
    "dart",
    "vimdoc",
    "vim",
    "regex",
  },
  autotag = {
    enable = true,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" } ]]

require('nvim-treesitter').setup {
	install_dir = vim.fn.stdpath('data') .. '/site'
}

require('nvim-treesitter').install {
	"markdown",
	"markdown_inline",
	"tsx",
	"javascript",
	"typescript",
	"toml",
	"json",
	"yaml",
	"lua",
	"go",
	"html",
	"css",
	"c_sharp",
	"http",
	"json",
	"rust",
	"c",
	"cpp",
	"dart",
	"vimdoc",
	"vim",
	"regex",
	-- DevOps
	"helm",
	"gotmpl",
	"dockerfile",
	"bash",
	"hcl",
	"terraform",
	"ini",
	"nginx",
	"ssh_config",
	"make",
}

-- Enable treesitter highlighting.
-- The main-branch rewrite of nvim-treesitter no longer auto-starts the
-- highlighter, so it must be started manually per buffer. Without this,
-- plugins checking vim.treesitter.highlighter.active (e.g. kustomize.nvim)
-- report "cannot load nvim-treesitter".
vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
