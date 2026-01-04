local u = require('config.utils')

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false, -- make sure to load this during startup
  priority = 1000, -- make sure to load this before all others
  config = function()
    require('catppuccin').setup({
      flavour = u.nvtmux_auto_started() and 'mocha' or 'latte',
      term_colors = true,
      transparent_background = u.nvtmux_auto_started(),
    })
    vim.cmd.colorscheme 'catppuccin'
  end
}
