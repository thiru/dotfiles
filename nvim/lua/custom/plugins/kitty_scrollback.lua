local u = require('custom.utils')

return {
  'thiru/kitty-scrollback.nvim',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started() and u.is_kitty_scrollback(),
  dev = true,
  opts = {
    colorscheme = 'catppuccin-mocha'
  },
}
