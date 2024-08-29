return {
  'thiru/nvtmux.nvim',
  cond = not vim.opt.diff:get() and nvtmux_auto_started(),
  dev = true,
  depedencies = {
    'gcmt/taboo.vim',
    'nvim-telescope/telescope.nvim'},
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
    {'<C-a>s', '<CMD>SshPicker<CR>', desc = 'Launch [S]SH connection picker'},
  },
}
