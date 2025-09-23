local status, wk = pcall(require, "which-key")
if not status then
	return
end

-- Using the new which-key API format for v3
wk.add({
	-- Define group names
	{ "<leader>f",  group = "Flutter" },
	{ "<leader>h",  group = "Hot" },

	-- Flutter commands
	{ "<leader>fe", "<cmd>FlutterEmulators<cr>",       desc = "Emulators" },
	{ "<leader>fd", "<cmd>FlutterDevices<cr>",         desc = "Devices" },
	{ "<leader>fc", "<cmd>FlutterCopyProfilerUrl<cr>", desc = "Run" },
	{ "<leader>fl", "<cmd>FlutterLogClear<cr>",        desc = "Logs" },
	{ "<leader>fq", "<cmd>FlutterQuit<cr>",            desc = "Quit" },
	{ "<leader>fo", "<cmd>FlutterOutlineToggle<cr>",   desc = "Flutter outline" },
	{ "<leader>fO", "<cmd>FlutterLogToggle<cr>",       desc = "Flutter log" },
	-- Hot reload/restart commands
	{ "<leader>hr", "<cmd>FlutterReload<cr>",          desc = "Hot Reload" },
	{ "<leader>hR", "<cmd>FlutterRestart<cr>",         desc = "Hot Restart" },
}, {
	mode = 'n',
	silent = true,
	noremap = true,
	nowait = true,
})
