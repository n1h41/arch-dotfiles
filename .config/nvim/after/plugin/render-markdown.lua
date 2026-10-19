vim.opt.conceallevel = 3


require('render-markdown').setup({
	latex = { enabled = false },
	file_types = { 'markdown', 'vimwiki', 'codecompanion' },
	completions = { lsp = { enabled = true } }
})

vim.treesitter.language.register('markdown', 'vimwiki')


vim.treesitter.language.register('markdown', 'codecompanion')
