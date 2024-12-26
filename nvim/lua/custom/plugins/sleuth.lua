local u = require('custom.utils')

return {
  'tpope/vim-sleuth',
  cond = not u.nvtmux_auto_started()
}
