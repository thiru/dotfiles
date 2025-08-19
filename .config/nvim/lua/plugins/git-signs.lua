local u = require('config.utils')

return {
  'lewis6991/gitsigns.nvim',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
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
