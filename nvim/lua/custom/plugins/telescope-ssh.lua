return {
  'thiru/telescope-ssh.nvim',
  cond = not vim.opt.diff:get() and nvtmux_auto_started(),
  dev = true,
  depedencies = {'nvim-telescope/telescope.nvim'},
  config = function()
    require('ssh').setup({
      auto_reconnect = {
        when = 'always'
      }
    })
  end,
  keys = {
    {'<C-a>s', '<CMD>Telescope ssh<CR>', desc = 'Open an [S]SH connection'},
  },
}
