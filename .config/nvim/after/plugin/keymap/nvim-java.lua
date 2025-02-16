local wk = require('which-key')
local status, java = pcall(require, 'java')
if (not status) then
  return
end

wk.add(
  {
    mode = { "n" },
    {
      "<leader>jr",
      function()
        java.runner.built_in.run_app({})
      end,
      desc = "Java run main method"
    }
  }
)
