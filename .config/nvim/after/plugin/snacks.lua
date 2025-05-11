require("snacks").setup({
  dashboard = {
    sections = {
      {
        pane = 2,
        { section = "keys",   gap = 1, padding = 1 },
        { section = "startup", padding = 1 },
      },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    },
  },
  image = {},
  animate = {},
  dim = {},
})
