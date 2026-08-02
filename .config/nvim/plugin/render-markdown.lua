local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({{
  name = 'render-markdown',
  src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}})
