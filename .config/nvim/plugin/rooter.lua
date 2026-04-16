local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/notjedi/nvim-rooter.lua',
  name = 'nvim-rooter',
  enabled = not u.diff_mode(),
  opts = {
    rooter_patterns = {'deps.edn', 'package.json', '.git', '.stfolder', '.rooter'}
  },
}
