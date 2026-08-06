local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({'https://github.com/nvim-mini/mini.extra'})

---@module 'mini.extra'
local plugin = require('mini.extra')
plugin.setup({})

vim.keymap.set('n', '<leader>sa', plugin.pickers.manpages, { desc = 'Search man pages' })
vim.keymap.set('n', '<leader>sc', plugin.pickers.commands, { desc = 'Search commands' })
vim.keymap.set('n', '<leader>sd', plugin.pickers.diagnostic, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>sk', plugin.pickers.keymaps, { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader>sm', plugin.pickers.marks, { desc = 'Search marks' })
vim.keymap.set('n', '<leader>so', plugin.pickers.oldfiles, { desc = 'Search old files' })
vim.keymap.set('n', '<leader>sr', plugin.pickers.registers, { desc = 'Search registers' })
vim.keymap.set('n', '<leader>sx', plugin.pickers.history, { desc = 'Search command history' })
