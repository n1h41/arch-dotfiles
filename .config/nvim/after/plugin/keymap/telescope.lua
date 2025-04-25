local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

local status2, telescope = pcall(require, "telescope.builtin")
if (not status2) then
  return
end

whichkey.add({
  -- Group registrations
  { "<leader>h",  group = "Help" },
  { "<leader>f",  group = "Find" },
  { "<leader>a",  group = "Actions" },

  -- Telescope commands
  { "<leader>ht", function() telescope.help_tags() end,                                      desc = "List help tags" },
  { "<leader>ff", function() telescope.find_files({ no_ignore = false, hidden = true }) end, desc = "Find files" },
  { "<leader>fr", function() telescope.live_grep({ no_ignore = false, hidden = true }) end,  desc = "Live Grep" },
  { "<leader>ac", function() telescope.commands() end,                                       desc = "List commands" },
}, {
  mode = "n",
  silent = true,
  noremap = true,
  nowait = false,
})

