return {
  'sotte/presenting.nvim',
  cond = not vim.opt.diff:get(),
  opts = {
    options = {
      width = 50,
    },
  },
  cmd = { 'Presenting' },
}
