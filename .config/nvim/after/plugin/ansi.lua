local status, ansi = pcall(require, "ansi")
if (not status) then
	return
end

ansi.setup({
	auto_enable = true,
	auto_enable_stdin = true,
	filetypes = { 'log', 'ansi', 'term' },
})
