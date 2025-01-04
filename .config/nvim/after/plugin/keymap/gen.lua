local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

whichkey.add(
  { "<leader>ai", "<cmd>Gen<cr>", desc = "AI", mode = { "n", "v" } }
)
