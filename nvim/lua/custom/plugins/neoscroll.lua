return {
  'karb94/neoscroll.nvim',
  cond = not vim.g.neovide,
  opts = {
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zz'},
  },
}
