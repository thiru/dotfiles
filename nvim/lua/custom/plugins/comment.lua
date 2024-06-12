return {
  'numToStr/Comment.nvim',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  opts = {}
}
