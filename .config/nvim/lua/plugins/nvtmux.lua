local u = require('config.utils')

return {
  'thiru/nvtmux.nvim',
  cond = not vim.opt.diff:get(),
  dev = true,
  depedencies = {'nvim-telescope/telescope.nvim'},
  opts = {
    auto_start = u.nvtmux_auto_started(),
    colorscheme = 'catppuccin-mocha',
  },
}
