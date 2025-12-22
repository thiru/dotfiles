return {
  'sindrets/diffview.nvim',
  cond = not vim.opt.diff:get(),
  lazy = false,
  keys = {
    { '<leader>gdb', '<CMD>DiffviewFileHistory<CR>', desc = 'Git DiffView branch' },
    { '<leader>gdf', '<CMD>DiffviewFileHistory %<CR>', desc = 'Git DiffView current file' },
    { '<leader>gdd', ':DiffviewOpen ', desc = 'Git DiffView open...' },
  }
}
