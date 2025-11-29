local u = require('config.utils')

return {
  "gpanders/nvim-parinfer",
  cond = not vim.opt.diff:get() and not u.has_rust(),
  ft = {'clojure', 'fennel', 'lisp'},
}
