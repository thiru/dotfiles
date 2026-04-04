local p = require('my.packin')

p.add{
  src = 'https://github.com/sindrets/diffview.nvim',
  name = 'diffview',
  cond = not vim.opt.diff:get(),
  after_load = function()
    vim.keymap.set('n', '<leader>gl', '<CMD>DiffviewFileHistory<CR>', {desc = 'Git branch log diffs'})
    vim.keymap.set('n', '<leader>gf', '<CMD>DiffviewFileHistory %<CR>', {desc = 'Git file history'})
    vim.keymap.set('n', '<leader>gs', '<CMD>DiffviewOpen HEAD<CR>', {desc = 'Git status'})
  end
}
