local p = require('my.packin')

-- deps: {'nvim-treesitter/nvim-treesitter'}, -- if you prefer nvim-web-devicons

p.add{
  src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  name = 'render-markdown',
  cond = not vim.opt.diff:get(),
}
