return {
  'thiru/nvtmux.nvim',
  cond = not vim.opt.diff:get() and nvtmux_auto_started(),
  dev = true,
  depedencies = {'nvim-telescope/telescope.nvim'},
  lazy = false,
  opts = {
    colorscheme = 'catppuccin-mocha',
    ssh = {
      auto_reconnect = {
        when = 'always'
      }
    },
  },
  keys = {
    {'<C-a>s', '<CMD>Ssh<CR>', desc = 'Open an [S]SH connection'},
  },
}
