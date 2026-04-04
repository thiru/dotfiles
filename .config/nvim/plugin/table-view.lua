local p = require('my.packin')

p.add{
  src = 'https://github.com/numEricL/table.vim',
  name = 'table_vim',
  cond = not vim.opt.diff:get(),
  opts = {
    options = {
      multiline = true
    }
  },
  after_load = function()
    vim.keymap.set('n', '<leader>Ta', '<CMD>Table Align<CR>', {desc = 'Search and Replace'})
  end
}
