return {
  'thiru/telescope-ssh.nvim',
  cond = not vim.opt.diff:get() and nvtmux_auto_started(),
  dev = true,
  depedencies = {'nvim-telescope/telescope.nvim'},
  config = function()
    vim.keymap.set('n', '<C-a>s', '<CMD>Telescope ssh<CR>', {desc = 'Open an [S]SH connection'})
  end
}
