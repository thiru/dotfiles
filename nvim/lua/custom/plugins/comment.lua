return {
  'numToStr/Comment.nvim',
  cond = not vim.opt.diff:get() and not require('custom.plain-term').is_enabled(),
  opts = {}
}
