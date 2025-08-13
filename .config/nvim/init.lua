-- Main Neovim config entrypoint
-- Loads core modules with error handling for missing files

local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify('Error loading module: ' .. module .. '\n' .. err, vim.log.levels.ERROR)
  end
end

safe_require('user.base')
safe_require('user.highlights')
safe_require('user.maps')
safe_require('user.plugin')
