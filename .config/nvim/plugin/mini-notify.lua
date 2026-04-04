local p = require('my.packin')

p.add{
  src = 'https://github.com/nvim-mini/mini.notify',
  opts = {},
  after_load = function(plugin)
    vim.keymap.set('n', '<leader>nh', plugin.show_history, { desc = 'Notify history' })
    vim.keymap.set('n', '<leader>nc', plugin.clear, { desc = 'Notify clear' })
  end
}
