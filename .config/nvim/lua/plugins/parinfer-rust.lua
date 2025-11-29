local u = require('config.utils')

return {
  "eraserhd/parinfer-rust",
  cond = not vim.opt.diff:get() and u.has_rust(),
  ft = {'clojure', 'fennel', 'lisp'},
  build = "cargo build --release",
}
