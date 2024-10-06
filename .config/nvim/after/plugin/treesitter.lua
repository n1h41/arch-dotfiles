local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

---@diagnostic disable-next-line: missing-fields
ts.setup {
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
    "vimdoc",
    "vim",
    "regex",
    "dart",
  },
  autotag = {
    enable = true,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
