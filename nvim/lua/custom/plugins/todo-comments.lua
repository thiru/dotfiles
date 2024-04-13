return {
  'folke/todo-comments.nvim',
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
