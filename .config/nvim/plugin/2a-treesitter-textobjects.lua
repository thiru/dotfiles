local p = require('my.packin')

p.add{
  src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  cond = not vim.opt.diff:get(),
}
