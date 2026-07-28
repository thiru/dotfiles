local u = require('my.utils')

if u.is_windows() or u.diff_mode() then return end

vim.pack.add({'https://github.com/lewis6991/gitsigns.nvim'})
