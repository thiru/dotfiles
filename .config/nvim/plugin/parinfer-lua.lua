local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/gpanders/nvim-parinfer',
  enabled = not u.diff_mode() and not u.has_rust(),
}
