local p = require('my.packin')

p.add{
  src = 'https://github.com/catppuccin/nvim',
  name = 'catppuccin',
  opts = {
    flavour = 'latte',
    term_colors = true,
  },
  after_load = function()
    vim.cmd.colorscheme('catppuccin-nvim')
  end
}
