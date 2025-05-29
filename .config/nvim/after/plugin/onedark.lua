local status, onedark = pcall(require, "onedark")

require("onedark.palette")

if (not status) then
  return
end

onedark.setup({
  style = "deep",
  transparent = false,
  toggle_style_key = "<leader>ts",
  code_style = {
    keywords = 'bold',
    strings = 'none',
    variables = 'none',
  },
  highlights = {
    ["DashboardHeader"] = { fg = "#FF4500" },
    ["DashboardFooter"] = { fg = "#e3e3e3" },
    ["DashboardShortCut"] = { fg = "white" },
    ["NormalFloat"] = { bg = "NONE" },
    ["HoverBorder"] = { bg = "NONE" },
    ["SagaBorder"] = { bg = "NONE" },
    ["FloatBorder"] = { bg = "NONE", fg = "#8BCD5B" },
    ["Pmenu"] = { bg = "NONE" },
    ["PmenuSel"] = { fg = "#e3e3e3" },
    ["PmenuSbar"] = { bg = "#1A212E" },
    ["PmenuThumb"] = { bg = "#8BCD5B" },
    ["BorderBg"] = { bg = "#8BCD5B" },
  }
})

onedark.load()
