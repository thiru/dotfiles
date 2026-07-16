vim.g['sneak#label'] = 1

vim.pack.add({'https://github.com/justinmk/vim-sneak'})

vim.keymap.set({'n', 'v'}, 'f', '<Plug>Sneak_s', {desc='Sneak (forward)'})
vim.keymap.set({'n', 'v'}, 'F', '<Plug>Sneak_S', {desc='Sneak (backward)'})
