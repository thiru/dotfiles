return {
  'MagicDuck/grug-far.nvim',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  opts = {},
  keys = {
    { '<leader>S', '<CMD>GrugFar<CR>', desc = 'Search and Replace' },
  }
}
