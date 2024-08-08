return {
  'eraserhd/parinfer-rust',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started() and not is_windows(),
  build = 'cargo build --release'
}
