return {
  'gpanders/nvim-parinfer',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  ft = {'clojure', 'edn'},
}
