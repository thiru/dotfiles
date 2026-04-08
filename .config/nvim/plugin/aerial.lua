local p = require('my.packin')
local u = require('my.utils')

-- deps: 'nvim-treesitter/nvim-treesitter',

p.add{
  src = 'https://github.com/stevearc/aerial.nvim',
  name = 'aerial',
  cond = not u.diff_mode(),
  after_load = function()
    require('aerial').setup({
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<CMD>AerialPrev<CR>', {buffer = bufnr, desc = 'Jump to previous symbol'})
        vim.keymap.set('n', '}', '<CMD>AerialNext<CR>', {buffer = bufnr, desc = 'Jump to next symbol'})
      end,
    })

    vim.keymap.set('n', '<leader>cn', '<CMD>AerialNavToggle<CR>', {desc='Aerial Nav'})
    vim.keymap.set('n', '<leader>cs', '<CMD>AerialToggle!<CR>', {desc='Aerial Symbols'})
  end
}
