local status, dashboard = pcall(require, "dashboard")

if (not status) then
  return
end

---@diagnostic disable-next-line: missing-fields
local git_dashboard = require('git-dashboard-nvim').setup {}

-- INFO: Code to add image to dashboard

--[[ local dashboardImage = vim.api.nvim_create_augroup("DashboardImage", { clear = true })
local img = require("image").from_file("/home/n1h41/Downloads/raf_logo.png")
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = dashboardImage,
  callback = function()
    img:render()
    img:move(1, 1)
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = dashboardImage,
  callback = function()
    img:clear()
  end,
}) ]]

dashboard.setup({
  theme = "doom",
  hide = {
    statusline = true,
    tabline = true,
    winbar = true,
  },
  config = {
    -- header = git_dashboard,
    header = {
      "                                   ",
      "                                   ",
      "                                   ",
      "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
      "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
      "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
      "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
      "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
      "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
      "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
      " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
      " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
      "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
      "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
      "                                   ",
    },
    center = {
      {
        icon = '󰈞  ',
        icon_hl = 'group',
        desc = 'Find Files',
        desc_hl = 'group',
        key = 'a',
        key_hl = 'group',
        action = 'Telescope find_files',
      },
      {
        icon = '  ',
        icon_hl = 'group',
        desc = 'Search Text',
        desc_hl = 'group',
        key = 'b',
        key_hl = 'group',
        action = 'Telescope live_grep',
      },
      {
        icon = '  ',
        icon_hl = 'group',
        desc = 'Recent Files',
        desc_hl = 'group',
        key = 'c',
        key_hl = 'group',
        action = 'Telescope oldfiles',
      },
    },
  }
})
