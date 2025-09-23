local u = require('config.utils')

return {
  'nvim-mini/mini.indentscope',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  version = false,
  config = true
}
