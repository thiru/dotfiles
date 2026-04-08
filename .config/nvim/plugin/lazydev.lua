local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/folke/lazydev.nvim',
  name = 'lazydev',
  cond = not u.diff_mode(),
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
