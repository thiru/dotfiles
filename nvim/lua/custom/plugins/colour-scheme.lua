local u = require('custom.utils')

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false, -- make sure to load this during startup
  priority = 1000, -- make sure to load this before all others
  config = function()
    require('catppuccin').setup({
      flavour = u.is_kitty_scrollback() and 'mocha' or 'latte',
      term_colors = true,
      transparent_background = u.is_kitty_scrollback(),
    })
    vim.cmd.colorscheme 'catppuccin'
  end
}
