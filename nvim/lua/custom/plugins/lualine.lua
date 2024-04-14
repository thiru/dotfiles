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
        function() return vim.fn.getcwd() end,
        'filename',
        'filesize'
      },
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
}
