local u = require('custom.utils')

return {
  'thiru/nvtmux.nvim',
  cond = not vim.opt.diff:get() and u.nvtmux_auto_started(),
  dev = true,
  depedencies = {
    'gcmt/taboo.vim',
    'nvim-telescope/telescope.nvim'},
  opts = {
    colorscheme = 'catppuccin-mocha',
  },
}
