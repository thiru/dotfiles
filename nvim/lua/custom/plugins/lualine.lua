-- Status line implemented using lualine
return {
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = true,
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch'},
      lualine_c = {'diagnostics'},
      lualine_x = {
        function()
          local abs_path = vim.api.nvim_buf_get_name(0)
          local cwd = vim.fn.getcwd()
          local rel_path = string.sub(abs_path, #cwd + 2)
          local home_dir = vim.loop.os_homedir() or ''
          if vim.startswith(cwd, home_dir) then
            cwd = '~' .. string.sub(cwd, #home_dir + 1)
          end
          cwd = ' ' .. cwd
          if #rel_path > 0 then
            return cwd .. " < " .. rel_path
          else
            return cwd
          end
        end,
        'filesize',
        'encoding',
        'fileformat',
      },
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
}
