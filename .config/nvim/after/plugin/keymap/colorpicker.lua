local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

local keymap = {
  c = {
    p = { "<cmd>PickColor<cr>", "Pick color" },
  }
}

whichkey.add(keymap, {
  silent = true,
  noremap = true,
})
