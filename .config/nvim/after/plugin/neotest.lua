---@diagnostic disable: missing-fields
local status, neotest = pcall(require, "neotest")
if (not status) then return end

neotest.setup({
  adapters = {
    require("neotest-dart")({
      -- command = vim.fn.stdpath('data') .. '/mason/bin/dart-debug-adapter',
      command = 'flutter',
      -- args = { 'flutter' },
      use_lsp = true,
      custom_test_method_names = {},
    }),
    require("neotest-go"),
    require("neotest-plenary"),
  }
})
