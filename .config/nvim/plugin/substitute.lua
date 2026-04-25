local p = require('my.packin')

p.add{
  src = 'https://github.com/gbprod/substitute.nvim',
  name = 'substitute',
  opts = {},
  after_load = function(plugin)
    vim.keymap.set('n', 's', plugin.operator, {desc = 'Substitute with motion'})
    vim.keymap.set('x', 's', plugin.visual, {desc = 'Substitute in visual mode'})
    vim.keymap.set('n', 'ss', plugin.line, {desc = 'Substitute line'})
    vim.keymap.set('n', 'S', plugin.eol, {desc = 'Substitute to end of line'})

    local exch = require('substitute.exchange')

    vim.keymap.set('n', 'sx', exch.operator, {desc = 'Exchange with motion'})
    vim.keymap.set('x', 'X', exch.visual, {desc = 'Exchange in visal mode'})
    vim.keymap.set('n', 'sxx', exch.line, {desc = 'Exchange line'})
  end,
}
