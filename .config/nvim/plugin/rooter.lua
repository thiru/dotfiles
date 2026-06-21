local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/wsdjeg/rooter.nvim',
  name = 'rooter',
  enabled = not u.diff_mode(),
  opts = {
    root_patterns = { '.git/' },
  }
}
