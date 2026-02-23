local ok, platformio = pcall(require, 'platformio')
if not ok then return end

platformio.setup({
	lsp = "clangd" --default: ccls, other option: clangd
	-- If you pick clangd, it also creates compile_commands.json
})
