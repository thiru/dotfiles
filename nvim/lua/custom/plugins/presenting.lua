return {
  'sotte/presenting.nvim',
  cond = not vim.opt.diff:get() and not require('custom.plain-term').is_enabled(),
  opts = {
    options = {
      width = 50,
    },
  },
  cmd = { 'Presenting' },
}
