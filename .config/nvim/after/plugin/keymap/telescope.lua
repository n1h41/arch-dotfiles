local status, wk = pcall(require, "which-key")
if (not status) then
	return
end

local status2, telescope = pcall(require, "telescope.builtin")
if (not status2) then
	return
end

-- Setup which-key mappings for Telescope
wk.add({
	{ "<leader>ht", function() telescope.help_tags() end,                                      desc = "List help tags", mode = "n" },
	{ "<leader>ff", function() telescope.find_files({ no_ignore = false, hidden = true }) end, desc = "Find files",     mode = "n" },
	{ "<leader>fr", function() telescope.live_grep({ no_ignore = false, hidden = true }) end,  desc = "Live Grep",      mode = "n" },
	{ "<leader>aC", function() telescope.commands() end,                                       desc = "List commands",  mode = "n" },
}, {
	silent = true, -- Don't echo commands
	noremap = true, -- Non-recursive mapping
	nowait = false, -- Wait for additional keypresses
	buffer = nil,  -- Apply to all buffers
})
