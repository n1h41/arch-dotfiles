local status, neotest = pcall(require, "neotest")
local status2, whichkey = pcall(require, "which-key")

if (not status) or (not status2) then
  return
end

whichkey.add({
  -- Group registration
  { "<leader>t",  group = "Tests" },

  -- Neotest commands
  { "<leader>tw", function() neotest.summary.toggle() end, desc = "Toggle test summary window" },
  { "<leader>tr", function() neotest.run.run() end,        desc = "Run nearest test" },
  {
    "<leader>td",
    function()
      local filetype = vim.bo.filetype
      if (filetype == "go") then
        require("dap-go").debug_test()
        return
      end
      ---@diagnostic disable-next-line: missing-fields
      neotest.run.run_last({ strategy = "dap" })
    end,
    desc = "Debug last runned test"
  },
  { "<leader>to", function() neotest.output.open() end,         desc = "Toggle output" },
  { "<leader>tO", function() neotest.output_panel.toggle() end, desc = "Toggle output panel" },
  { "<leader>tc", function() neotest.output_panel.clear() end,  desc = "Clear output panel" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})

