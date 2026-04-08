local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/gpanders/nvim-parinfer',
  cond = not u.diff_mode() and not u.has_rust(),
}
