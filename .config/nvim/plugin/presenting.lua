local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/sotte/presenting.nvim',
  name = 'presenting',
  cond = not u.diff_mode(),
  opts = {
    options = {
      width = 50,
    },
  },
}
