local ok, platformio = pcall(require, 'platformio')
if not ok then return end

platformio.setup({
	lsp = "clangd"
})
