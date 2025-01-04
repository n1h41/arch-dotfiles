local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

local keymap = {
  r = {
    name = "Rest",
    r = {
      "<cmd>Rest run<CR>", "List"
    }
  }
}

whichkey.add(keymap, {
  prefix = "<leader>",
  mode = "n",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
})
