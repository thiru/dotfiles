return {
  'eraserhd/parinfer-rust',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  build = 'cargo build --release'
}
