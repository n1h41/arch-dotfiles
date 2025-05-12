require("snacks").setup({
  dashboard = {
    preset = {
      keys = {
        {
          icon = "󰈢 ",
          key = "f",
          desc = "Find Files",
          action = ":Telescope find_files"
        },
        {
          icon = "󰥔 ",
          key = "r",
          desc = "Recent Files",
          action = ":Telescope oldfiles"
        },
        {
          icon = "󰍉 ",
          key = "s",
          desc = "Search Text",
          action = ":Telescope live_grep"
        },
        {
          icon = "󱎸 ",
          key = "t",
          desc = "Find Text",
          action = ":Telescope grep_string"
        },
        {
          icon = "󱂫 ",
          key = "p",
          desc = "Recent Projects",
          -- Using the built-in projects picker
          action = function()
            require("snacks.dashboard").pick("projects", {
              -- Optional settings
              limit = 10,    -- number of projects to show
              pick = true,   -- use picker to select project
              session = true -- try to restore session when opening project
            })
          end
        },
      },
    },
    sections = {
      {
        { section = "keys",    gap = 1,    padding = 1 },
        { section = "startup", padding = 1 },
      }
    },
  },
  image = {},
  animate = {},
  dim = {},
})
