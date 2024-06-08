return {
  'folke/todo-comments.nvim',
  cond = not vim.opt.diff:get() and not require('custom.plain-term').is_enabled(),
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    highlight = {
      comments_only = false
    },
    keywords = {
      WAIT = {color = 'warning', alt = {'WAITING', 'BLOCKED'}}
    },
    signs = false
  }
}
