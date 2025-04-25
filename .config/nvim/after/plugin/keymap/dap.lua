local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Add the mappings with the new API
wk.add({
  -- Debug mappings nested under <leader>
  { "<leader>",    mode = "n" },

  -- Breakpoint section
  { "<leader>b",   group = "Breakpoints" },
  { "<leader>bc",  "<cmd>lua require'dap'.clear_breakpoints()<cr>", desc = "Clean breakpoints", mode = "n" },
  { "<leader>bl",  "<cmd>lua require'dap'.list_breakpoints()<cr>",  desc = "List breakpoints",  mode = "n" },

  -- Debug section
  { "<leader>d",   group = "Debug" },
  { "<leader>dc",  "<cmd>lua require'dap'.continue()<cr>",          desc = "Continue",          mode = "n" },
  { "<leader>dd",  "<cmd>lua require'dap'.disconnect()<cr>",        desc = "Disconnect",        mode = "n" },
  { "<leader>de",  "<cmd>lua require'dapui'.eval()<cr>",            desc = "Evaluate",          mode = "n" },
  { "<leader>dh",  "<cmd>lua require'dap.ui.widgets'.hover()<cr>",  desc = "Hover Variables",   mode = "n" },
  { "<leader>di",  "<cmd>lua require'dap'.step_into()<cr>",         desc = "Step Into",         mode = "n" },
  { "<leader>do",  "<cmd>lua require'dap'.step_over()<cr>",         desc = "Step Over",         mode = "n" },
  { "<leader>dq",  "<cmd>lua require'dap'.close()<cr>",             desc = "Quit",              mode = "n" },
  { "<leader>dt",  "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint", mode = "n" },
  { "<leader>dx",  "<cmd>lua require'dap'.terminate()<cr>",         desc = "Terminate",         mode = "n" },

  -- UI section nested under Debug
  { "<leader>du",  group = "UI",                                    mode = "n" },
  { "<leader>dui", "<cmd>lua require'dapui'.toggle()<cr>",          desc = "Toggle UI",         mode = "n" },
  {
    "<leader>dus",
    function()
      local widgets = require("dap.ui.widgets")
      local sidebar = widgets.sidebar(widgets.scopes)
      sidebar.open()
    end,
    desc = "UI Sidebar",
    mode = "n"
  },

  -- Go section
  { "<leader>g",  group = "Go",    mode = "n" },
  { "<leader>gd", group = "Debug", mode = "n" },
  {
    "<leader>gdt",
    function()
      require("dap-go").debug_test()
    end,
    desc = "Debug Go test",
    mode = "n"
  },
  {
    "<leader>gdl",
    function()
      require("dap-go").debug_last()
    end,
    desc = "Debug Last Go test",
    mode = "n"
  },

  -- Visual mode mappings
  { "<leader>",   mode = "v" },
  { "<leader>d",  group = "Debug",                      mode = "v" },
  { "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", desc = "Evaluate", mode = "v" },
})

