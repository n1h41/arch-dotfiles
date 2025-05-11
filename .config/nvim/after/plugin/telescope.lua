local status, telescope = pcall(require, 'telescope')
if (not status) then return end
local actions = require('telescope.actions')

telescope.setup {
  pickers = {
    find_files = {
      hidden = true
    },
  },
  defaults = {
    sorting_strategy = "ascending",
    dynamic_preview_title = true,
    layout_config = {
      height = 0.6,
      -- width = 0.9,
      prompt_position = "top",
      anchor = 'S'
    },
    mappings = {
      n = {
        ['q'] = actions.close
      },
      i = {
        ['<C-b>'] = actions.preview_scrolling_up,
        ['<C-f>'] = actions.preview_scrolling_down,
      }
    },
    file_ignore_patterns = {
      ".git/",
      "node_modules",
    },
  }
}
