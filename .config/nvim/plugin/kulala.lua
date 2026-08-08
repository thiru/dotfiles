local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({'https://github.com/mistweaverco/kulala.nvim'})

require('kulala').setup({
  global_keymaps = true,
  global_keymaps_prefix = "<leader>r",
})
