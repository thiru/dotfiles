local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({{
  name = 'rooter',
  src = 'https://github.com/wsdjeg/rooter.nvim',
}})

require('rooter').setup({
  root_patterns = { '.git/' },
})
