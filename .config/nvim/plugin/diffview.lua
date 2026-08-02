local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({{
  name = 'diffview',
  src = 'https://github.com/sindrets/diffview.nvim',
}})

vim.keymap.set('n', '<leader>gl', '<CMD>DiffviewFileHistory<CR>', {desc = 'Git branch log diffs'})
vim.keymap.set('n', '<leader>gf', '<CMD>DiffviewFileHistory %<CR>', {desc = 'Git file history'})
vim.keymap.set('n', '<leader>gs', '<CMD>DiffviewOpen HEAD<CR>', {desc = 'Git status'})
