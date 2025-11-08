return {
  'lewis6991/gitsigns.nvim',
  cond = not vim.opt.diff:get(),
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    }
  }
}
