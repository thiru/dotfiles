return {
  'nvim-pack/nvim-spectre',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  cmd = 'Spectre',
  keys = {
    { '<leader>S', function() require('spectre').toggle() end, desc = 'Replace in files (Spectre)' },
  },
}
