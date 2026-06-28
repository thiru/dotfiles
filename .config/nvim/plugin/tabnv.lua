local p = require('my.packin')
local u = require('my.utils')
local neovide = require('my.neovide')

p.add{
  src = 'https://github.com/thiru/tabnv.nvim',
  dev_src = 'file:///~/code/tabnv.nvim',
  name = 'tabnv',
  enabled = not u.diff_mode(),
  opts = {
    colorscheme = 'catppuccin-mocha',
    neovide_opacity = neovide.terminal_opacity_override,
  }
}
