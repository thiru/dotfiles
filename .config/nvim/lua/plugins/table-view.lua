return {
  'numEricL/table.vim',
  cond = not vim.opt.diff:get(),
  opts = {
    options = {
      multiline = true
    }
  },
  keys = {
    { '<leader>Ta', '<CMD>Table Align<CR>', desc = 'Search and Replace' },
  }
}
