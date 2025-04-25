local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

wk.add({
  {
    "<leader>dg", -- assuming you're using <leader> prefix, adjust if needed
    group = "Debug Go",
    mode = "n",
  },
  {
    "<leader>dgt",
    function()
      require("dap-go").debug_test()
    end,
    desc = "Debug test",
    mode = "n",
  },
  {
    "<leader>dgl",
    function()
      require("dap-go").debug_last()
    end,
    desc = "Debug last",
    mode = "n",
  }
})


