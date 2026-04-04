local p = require('my.packin')

p.add{
  src = 'https://github.com/notjedi/nvim-rooter.lua',
  name = 'nvim-rooter',
  cond = not vim.opt.diff:get(),
  opts = {
    rooter_patterns = {'deps.edn', 'package.json', '.git', '.stfolder', '.rooter'}
  },
}
