return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false, -- make sure to load this during startup
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('catppuccin').setup({
      flavour = 'latte',
      term_colors = true,
    })
    vim.cmd.colorscheme 'catppuccin'
  end
}
