local p = require('my.packin')
local u = require('my.utils')

-- deps: {'nvim-treesitter/nvim-treesitter'}, -- if you prefer nvim-web-devicons

p.add{
  src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  name = 'render-markdown',
  cond = not u.diff_mode(),
}
