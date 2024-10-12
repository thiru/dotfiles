return {
  'thiru/neodba.nvim',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  dev = true,
  config = true,
  ft = 'sql',
}
