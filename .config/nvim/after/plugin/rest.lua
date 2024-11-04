local status, rest = pcall(require, "rest-nvim")
if (not status) then return end

require("telescope").load_extension("rest")
