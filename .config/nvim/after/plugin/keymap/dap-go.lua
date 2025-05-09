local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

-- Use the new add() method for proper mapping specifications
whichkey.add({
  -- Define leader key as the root prefix
  {
    -- Required lhs field
    "<leader>d",
    -- Group definition
    group = "Debug",
    -- Create nested group
    {
      -- Required lhs field for nested group
      "<leader>dg",
      group = "Go Debug",
      -- Nested commands
      {
        "<leader>dgt",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debug test",
      },
      {
        "<leader>dgl",
        function()
          require("dap-go").debug_last()
        end,
        desc = "Debug last",
      }
    }
  }
}, {
  mode = "n",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
})
