local p = require('my.packin')

p.add{
  src = 'https://github.com/sotte/presenting.nvim',
  name = 'presenting',
  cond = not vim.opt.diff:get(),
  opts = {
    options = {
      width = 50,
    },
  },
}
