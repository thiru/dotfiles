return {
  'sindrets/diffview.nvim',
  cond = not vim.opt.diff:get(),
  lazy = false,
  keys = {
    { '<leader>gdb', '<CMD>DiffviewFileHistory<CR>', desc = 'Git DiffView branch' },
    { '<leader>gdd', ':DiffviewOpen ', desc = 'Git DiffView open...' },
    { '<leader>gdf', '<CMD>DiffviewFileHistory %<CR>', desc = 'Git DiffView current file' },
    { '<leader>gds', ':DiffviewOpen HEAD<CR>', desc = 'Git DiffView status' },
  }
}
