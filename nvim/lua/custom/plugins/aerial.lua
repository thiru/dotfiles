local u = require('custom.utils')

return {
  'stevearc/aerial.nvim',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  dependencies = {
     'nvim-treesitter/nvim-treesitter',
     'nvim-tree/nvim-web-devicons'
  },
  opts = {
    on_attach = function(bufnr)
      vim.keymap.set('n', '{', '<CMD>AerialPrev<CR>', {buffer = bufnr, desc = 'Jump to previous symbol'})
      vim.keymap.set('n', '}', '<CMD>AerialNext<CR>', {buffer = bufnr, desc = 'Jump to nextt symbol'})
    end, },
  keys = {
    {'<leader>cn', '<CMD>AerialNavToggle<CR>', desc = 'Aerial Nav'},
    {'<leader>cs', '<CMD>AerialToggle!<CR>', desc = 'Aerial Symbols'},
  },
}
