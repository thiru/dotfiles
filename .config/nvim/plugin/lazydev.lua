local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({{
  src = 'https://github.com/folke/lazydev.nvim',
  name = 'lazydev',
}})

require('lazydev').setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
