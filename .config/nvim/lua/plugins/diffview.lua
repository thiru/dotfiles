return {
  'sindrets/diffview.nvim',
  cond = not vim.opt.diff:get(),
  lazy = false,
  keys = {
    { '<leader>gl', '<CMD>DiffviewFileHistory<CR>', desc = 'Git branch log diffs' },
    { '<leader>gf', '<CMD>DiffviewFileHistory %<CR>', desc = 'Git file history' },
    { '<leader>gs', '<CMD>DiffviewOpen HEAD<CR>', desc = 'Git status' },
  }
}
