local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

local keymap = {
  mode = { "n" },
  { "<leader>pr", "<cmd>Piorun<CR>", desc = "Platformio Run" },
  { "<leader>pm", "<cmd>Piomon<CR>", desc = "Platformio Monitor" },
}

whichkey.add(keymap)
