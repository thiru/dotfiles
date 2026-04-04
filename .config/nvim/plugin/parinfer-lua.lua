local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/gpanders/nvim-parinfer',
  cond = not vim.opt.diff:get() and not u.has_rust(),
}
