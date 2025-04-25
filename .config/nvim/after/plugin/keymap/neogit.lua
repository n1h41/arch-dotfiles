local status, whichkey = pcall(require, "which-key")
if not status then
  return
end

whichkey.add({
  -- Group registration
  { "<leader>g",  group = "Git" },

  -- Neogit command
  { "<leader>gG", function() require('neogit').open() end, desc = "Open Neogit" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = true,
})

