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
      lualine_b = {'branch', 'diagnostics'},
      lualine_c = {
        function()
          return vim.fn.getcwd()
        end
      },
      lualine_x = {'filename', 'filesize'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
}
