local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/MagicDuck/grug-far.nvim',
  name = 'grug-far',
  cond = not u.diff_mode(),
  opts = {},
  after_load = function()
    vim.keymap.set('n',  '<leader>S', '<CMD>GrugFar<CR>', {desc = 'Search and Replace'})
  end
}
