vim.pack.add({'https://github.com/nvim-mini/mini.notify'})

local plugin = require('mini.notify')
plugin.setup()

vim.keymap.set('n', '<leader>nh', plugin.show_history, { desc = 'Notify history' })
vim.keymap.set('n', '<leader>nc', plugin.clear, { desc = 'Notify clear' })
