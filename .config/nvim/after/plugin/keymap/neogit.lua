local status, wk = pcall(require, "which-key")
if not status then
  return
end

-- Using the new which-key API format for v3
wk.add({
  -- Define group name
  { "<leader>g", group = "Git" },

  -- Neogit command with function as the action
  {
    "<leader>gG",
    function()
      require('neogit').open()
    end,
    desc = "Open Neogit"
  },
}, {
  mode = 'n',
  silent = true,
  noremap = true,
  nowait = true,
})

