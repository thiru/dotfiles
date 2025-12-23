return {
  'nvim-mini/mini.pick',
  cond = not vim.opt.diff:get(),
  version = false,
  opts = {
    mappings = {
      choose_marked = '<C-CR>',
      mark = '<Tab>',
      move_down = '<C-j>',
      move_start = '<C-g>',
      move_up = '<C-k>',
      paste = '<C-v>',
    }
  },
}
