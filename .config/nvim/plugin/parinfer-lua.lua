local u = require('my.utils')
if u.diff_mode() or u.has_rust() then return end

vim.pack.add({'https://github.com/gpanders/nvim-parinfer'})
