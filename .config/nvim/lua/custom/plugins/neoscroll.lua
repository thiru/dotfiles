return {
  'karb94/neoscroll.nvim',
  cond = not vim.g.neovide,
  opts = {
    duration_multiplier = 0.5,
    easing = 'quadratic',
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zz'},
  },
}
