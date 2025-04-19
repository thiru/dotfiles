local u = require('custom.utils')

return {
  'eraserhd/parinfer-rust',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started() and not u.is_windows() and u.has_glibc_version(2,33),
  build = 'cargo build --release'
}
