local status, lualine = pcall(require, "lualine")
if (not status) then return end

local function date()
  -- return os.date("%Y-%m-%d")  -- Format: YYYY-MM-DD
  -- Alternatives:
  return os.date("%d/%m/%Y") -- Format: DD/MM/YYYY
  -- return os.date("%B %d, %Y")  -- Format: Month Day, Year
end

lualine.setup {
  options = {
    icons_enabled = true,
    -- theme = 'solarized_dark',
    theme = 'auto',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = {
      'NvimTree',
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 0            -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_x = {
      function()
        return vim.g.mcphub_lualine_status or ''
      end,
      {
        'diagnostics',
        sources = { "nvim_diagnostic" },
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = ' '
        }
      },
      { date },
      'encoding',
      'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_x = { 'location' },
    lualine_y = { },
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'fugitive' }
}
