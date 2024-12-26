local u = require('custom.utils')

return {
  'thiru/neodba.nvim',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  dev = true,
  config = true,
  ft = 'sql',
}
