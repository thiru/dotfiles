return {
  'thiru/nvtmux.nvim',
  cond = not vim.opt.diff:get() and nvtmux_auto_started(),
  dev = true,
  depedencies = {
    'gcmt/taboo.vim',
    'nvim-telescope/telescope.nvim'},
  opts = {
    colorscheme = 'catppuccin-mocha',
    ssh = {
      auto_reconnect = {
        when = is_windows() and 'always' or 'on_error'
      }
    },
  },
}
