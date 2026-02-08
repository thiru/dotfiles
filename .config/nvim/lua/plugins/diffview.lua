return {
  'sindrets/diffview.nvim',
  cond = not vim.opt.diff:get(),
  lazy = false,
  keys = {
    { '<leader>gb', '<CMD>DiffviewFileHistory<CR>', desc = 'Git DiffView branch' },
    { '<leader>gdd', ':DiffviewOpen ', desc = 'Git DiffView open...' },
    { '<leader>gdf', '<CMD>DiffviewFileHistory %<CR>', desc = 'Git DiffView current file' },
    { '<leader>gs', ':DiffviewOpen HEAD<CR>', desc = 'Git DiffView status' },
  }
}
