local p = require('my.packin')
local u = require('my.utils')
local neovide = require('my.neovide')

p.add{
  src = 'https://github.com/thiru/nvtmux.nvim',
  dev_src = 'file:///~/code/nvtmux.nvim',
  name = 'nvtmux',
  enabled = not u.diff_mode(),
  opts = {
    colorscheme = 'catppuccin-mocha',
    neovide_opacity = neovide.terminal_opacity_override,
  }
}
