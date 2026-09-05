local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({'https://github.com/chrisgrieser/nvim-chainsaw'})

local plugin = require('chainsaw')
plugin.setup({})

vim.keymap.set('n', '<leader>ll', plugin.variableLog, {desc = 'Load Conjure'})
