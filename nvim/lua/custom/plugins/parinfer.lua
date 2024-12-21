return {
  'eraserhd/parinfer-rust',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started() and not is_windows() and has_glibc_version(2,33),
  build = 'cargo build --release'
}
