local status, whichkey = pcall(require, "which-key")
if (not status) then
  return
end

-- Using the new which-key API (v3+)
whichkey.add({
  {
    "<leader>c",
    group = "Copilot"
  },
  {
    "<leader>cd",
    "<cmd>Copilot disable<CR>",
    desc = "Disable copilot",
    mode = "n"
  },
  {
    "<leader>ce",
    "<cmd>Copilot enable<CR>",
    desc = "Enable copilot",
    mode = "n"
  }
}, {
  silent = true,
  noremap = true,
  nowait = false,
})

