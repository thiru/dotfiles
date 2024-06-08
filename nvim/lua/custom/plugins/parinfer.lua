return {
  'gpanders/nvim-parinfer',
  cond = not vim.opt.diff:get() and not require('custom.plain-term').is_enabled(),
  ft = {'clojure', 'edn'},
}
