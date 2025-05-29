local status, wk = pcall(require, "which-key")
if (not status) then
  return
end

local snacks = require("snacks")

-- Setup which-key mappings for DAP
wk.add({
  -- Breakpoint commands
  {
    "<leader>zm",
    function() snacks.zen() end,
    desc = "Clean breakpoints",
    mode = "n"
  },
  {
    "<leader>zz",
    function()
      snacks.zen.zoom()
    end,
    desc = "List breakpoints",
    mode = "n"
  },
  {
    "<leader>pp",
    function()
      snacks.picker.projects()
    end,
    desc = "Recent Projects",
    mode = "n"
  },
}, {
  silent = true,  -- Don't echo commands
  noremap = true, -- Non-recursive mapping
  nowait = false, -- Wait for additional keypresses
  buffer = nil,   -- Apply to all buffers
})
