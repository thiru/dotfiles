return {
  'eraserhd/parinfer-rust',
  enabled = function()
    return not is_windows()
  end,
  build = 'cargo build --release'
}
