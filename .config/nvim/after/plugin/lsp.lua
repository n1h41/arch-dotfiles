-- LSP configuration entrypoint.
-- Loaded from after/plugin/ so it runs AFTER all plugins have loaded.
-- Actual logic is modularized under lua/user/lsp/:
--   - init.lua        : shared capabilities, on_attach, templ_format, mason
--   - servers.lua     : vim.lsp.config server definitions
--   - cmp.lua         : nvim-cmp completion
--   - diagnostics.lua : diagnostic config + LSP patches

local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify('Error loading LSP module: ' .. module .. '\n' .. err, vim.log.levels.ERROR)
  end
end

safe_require('user.lsp')           -- shared setup (loads first, providers for others)
safe_require('user.lsp.servers')   -- server definitions
safe_require('user.lsp.cmp')       -- completion
safe_require('user.lsp.diagnostics') -- diagnostics + patches
