return {
  'folke/todo-comments.nvim',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
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
