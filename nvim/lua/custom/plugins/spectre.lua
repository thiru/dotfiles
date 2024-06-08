return {
  'nvim-pack/nvim-spectre',
  cond = not vim.opt.diff:get() and not require('custom.plain-term').is_enabled(),
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  cmd = 'Spectre',
  keys = {
    { '<leader>S', function() require('spectre').toggle() end, desc = 'Replace in files (Spectre)' },
  },
}
