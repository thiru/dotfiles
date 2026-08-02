local u = require('mine.utils')

if u.diff_mode() then return end

-- NOTE: deps: 'nvim-treesitter/nvim-treesitter',

vim.pack.add({{
  name = 'aerial',
  src = 'https://github.com/stevearc/aerial.nvim',
}})

require('aerial').setup({
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<CMD>AerialPrev<CR>', {buffer = bufnr, desc = 'Jump to previous symbol'})
    vim.keymap.set('n', '}', '<CMD>AerialNext<CR>', {buffer = bufnr, desc = 'Jump to next symbol'})
  end,
})

vim.keymap.set('n', '<leader>cn', '<CMD>AerialNavToggle<CR>', {desc='Aerial Nav'})
vim.keymap.set('n', '<leader>cs', '<CMD>AerialToggle!<CR>', {desc='Aerial Symbols'})
