local u = require('config.utils')

return {
  'gpanders/nvim-parinfer',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started()
}
