vim.pack.add({'https://github.com/nvim-mini/mini-git'})

require('mini.git').setup()

vim.keymap.set({'n', 'v'}, 'g<leader>', ':Git ', {desc = 'mini-git prompt'})
