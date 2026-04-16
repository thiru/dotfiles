local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  enabled = not u.diff_mode(),
}
