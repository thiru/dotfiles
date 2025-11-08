return {
  'MagicDuck/grug-far.nvim',
  cond = not vim.opt.diff:get(),
  opts = {},
  keys = {
    { '<leader>S', '<CMD>GrugFar<CR>', desc = 'Search and Replace' },
  }
}
