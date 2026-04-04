local p = require('my.packin')

p.add{
  src = 'https://github.com/folke/lazydev.nvim',
  name = 'lazydev',
  cond = not vim.opt.diff:get(),
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
