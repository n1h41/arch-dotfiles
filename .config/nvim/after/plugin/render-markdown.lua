require('render-markdown').setup({
  debounce = 100,
  file_types = { 'markdown', 'vimwiki', 'codecompanion' },
  overrides = {
    buftype = {
      nofile = {
        padding = { highlight = 'NormalFloat' },
        sign = { enabled = false },
      },
      markdown = {
        sign = { enabled = false },
      }
    },
    filetype = {},
  },
})
