if require('my.utils').diff_mode() then return end

vim.pack.add({'https://github.com/nvim-mini/mini.bufremove'})

local plugin = require('mini.bufremove')

plugin.setup({
  silent = true,
})

vim.keymap.set('n', '<leader>d', plugin.delete, {desc = 'Delete buffer'})
vim.keymap.set('n', '<leader>D',
  function() plugin.wipeout(0, true) end,
  {desc = 'Delete buffer (ignore unsaved changes)'})
