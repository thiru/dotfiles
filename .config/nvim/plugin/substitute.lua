local p = require('my.packin')

p.add{
  src = 'https://github.com/gbprod/substitute.nvim',
  name = 'substitute',
  opts = {},
  after_load = function(plugin)
    vim.keymap.set('n', '<leader>p', plugin.operator, {desc = 'Substitute with motion'})
    vim.keymap.set('n', '<leader>pp', plugin.line, {desc = 'Substitute line'})
    vim.keymap.set('n', '<leader>pP', plugin.eol, {desc = 'Substitute to end of line'})
    vim.keymap.set('x', '<leader>p', plugin.visual, {desc = 'Substitute in visual mode'})
  end,
}
