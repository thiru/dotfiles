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
      lualine_c = {
        function()
          local abs_path = vim.api.nvim_buf_get_name(0)
          local cwd = vim.fn.getcwd()
          return string.sub(abs_path, #cwd + 2)
        end,
      },
      lualine_x = {
        function() return vim.fn.getcwd() end,
        'diagnostics',
        'filesize',
        'encoding',
        'fileformat',
      },
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
}
