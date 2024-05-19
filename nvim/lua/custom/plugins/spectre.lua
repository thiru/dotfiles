return {
  'nvim-pack/nvim-spectre',
  enabled = function()
    return not vim.opt.diff:get()
  end,
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  cmd = 'Spectre',
  keys = {
    { '<leader>S', function() require('spectre').toggle() end, desc = 'Replace in files (Spectre)' },
  },
}
