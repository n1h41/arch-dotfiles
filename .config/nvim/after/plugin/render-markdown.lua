vim.opt.conceallevel = 3


require('render-markdown').setup({
  file_types = { 'markdown', 'vimwiki', 'codecompanion' },
})

vim.treesitter.language.register('markdown', 'vimwiki')


vim.treesitter.language.register('markdown', 'codecompanion')
