local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/sindrets/diffview.nvim',
  name = 'diffview',
  cond = not u.diff_mode(),
  after_load = function()
    vim.keymap.set('n', '<leader>gl', '<CMD>DiffviewFileHistory<CR>', {desc = 'Git branch log diffs'})
    vim.keymap.set('n', '<leader>gf', '<CMD>DiffviewFileHistory %<CR>', {desc = 'Git file history'})
    vim.keymap.set('n', '<leader>gs', '<CMD>DiffviewOpen HEAD<CR>', {desc = 'Git status'})
  end
}
