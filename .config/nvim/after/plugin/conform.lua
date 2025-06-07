local confirm = require("conform")

confirm.setup({
  formatters_by_ft = {
    nasm = { "asmfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})
