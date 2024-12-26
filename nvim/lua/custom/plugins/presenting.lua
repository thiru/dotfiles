local u = require('custom.utils')

return {
  'sotte/presenting.nvim',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  opts = {
    options = {
      width = 50,
    },
  },
  cmd = { 'Presenting' },
}
