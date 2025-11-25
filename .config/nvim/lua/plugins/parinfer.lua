return {
  "eraserhd/parinfer-rust",
  cond = not vim.opt.diff:get(),
  build = "cargo build --release"
}
