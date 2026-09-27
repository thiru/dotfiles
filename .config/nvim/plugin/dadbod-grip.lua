local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({'https://github.com/joryeugene/dadbod-grip.nvim'})

local plugin = require('dadbod-grip')
plugin.setup()

vim.keymap.set('n', '<localleader>dc', '<CMD>GripConnect<CR>', {desc = 'Database connections'})
