local p = require('my.packin')

p.add{
  src = 'https://github.com/MagicDuck/grug-far.nvim',
  name = 'grug-far',
  cond = not vim.opt.diff:get(),
  opts = {},
  after_load = function()
    vim.keymap.set('n',  '<leader>S', '<CMD>GrugFar<CR>', {desc = 'Search and Replace'})
  end
}
