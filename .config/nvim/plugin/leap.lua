vim.pack.add({'https://codeberg.org/andyg/leap.nvim'})

vim.keymap.set({ 'n', 'x', 'o' }, '<leader>f', '<Plug>(leap)')
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>F', '<Plug>(leap-anywhere)')
