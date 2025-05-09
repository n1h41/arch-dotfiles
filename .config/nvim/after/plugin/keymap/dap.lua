local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

-- Setup which-key mappings for DAP
wk.add({
  -- Breakpoint commands
  { "<leader>bc",  "<cmd>lua require'dap'.clear_breakpoints()<cr>", desc = "Clean breakpoints", mode = "n" },
  { "<leader>bl",  "<cmd>lua require'dap'.list_breakpoints()<cr>",  desc = "List breakpoints",  mode = "n" },

  -- Debug commands
  { "<leader>dc",  "<cmd>lua require'dap'.continue()<cr>",          desc = "Continue",          mode = "n", group = "Debug" },
  { "<leader>dd",  "<cmd>lua require'dap'.disconnect()<cr>",        desc = "Disconnect",        mode = "n", group = "Debug" },
  { "<leader>de",  "<cmd>lua require'dapui'.eval()<cr>",            desc = "Evaluate",          mode = "n", group = "Debug" },
  { "<leader>dh",  "<cmd>lua require'dap.ui.widgets'.hover()<cr>",  desc = "Hover Variables",   mode = "n", group = "Debug" },
  { "<leader>di",  "<cmd>lua require'dap'.step_into()<cr>",         desc = "Step Into",         mode = "n", group = "Debug" },
  { "<leader>do",  "<cmd>lua require'dap'.step_over()<cr>",         desc = "Step Over",         mode = "n", group = "Debug" },
  { "<leader>dq",  "<cmd>lua require'dap'.close()<cr>",             desc = "Quit",              mode = "n", group = "Debug" },
  { "<leader>dt",  "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint", mode = "n", group = "Debug" },
  { "<leader>dui", "<cmd>lua require'dapui'.toggle()<cr>",          desc = "Toggle UI",         mode = "n", group = "Debug UI" },
  {
    "<leader>dus",
    function()
      local widgets = require("dap.ui.widgets")
      local sidebar = widgets.sidebar(widgets.scopes)
      sidebar.open()
    end,
    desc = "UI Sidebar",
    mode = "n",
    group = "Debug UI"
  },
  { "<leader>dx",  "<cmd>lua require'dap'.terminate()<cr>",       desc = "Terminate",          mode = "n", group = "Debug" },

  -- Go debug commands
  { "<leader>gdt", function() require("dap-go").debug_test() end, desc = "Debug Go test",      mode = "n", group = "Go Debug" },
  { "<leader>gdl", function() require("dap-go").debug_last() end, desc = "Debug Last Go test", mode = "n", group = "Go Debug" },

  -- Visual mode debug commands
  { "<leader>de",  "<cmd>lua require'dapui'.eval()<cr>",          desc = "Evaluate",           mode = "v", group = "Debug" },
}, {
  silent = true,  -- Don't echo commands
  noremap = true, -- Non-recursive mapping
  nowait = false, -- Wait for additional keypresses
  buffer = nil,   -- Apply to all buffers
})
