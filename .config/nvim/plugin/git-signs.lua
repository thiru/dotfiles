local u = require('mine.utils')

if u.is_windows() or u.diff_mode() then return end

vim.pack.add({'https://github.com/lewis6991/gitsigns.nvim'})

require('gitsigns').setup()

vim.keymap.set('n',  '<leader>gb', '<CMD>Gitsigns toggle_current_line_blame<CR>', {desc = 'Blame toggle'})
