local u = require('custom.utils')

return {
  'akinsho/bufferline.nvim',
  cond = not u.nvtmux_auto_started(),
  opts = {
    options = {
      always_show_bufferline = false,
    }
  }
}
