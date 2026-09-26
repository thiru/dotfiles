local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({'https://github.com/nvim-mini/mini.extra'})

---@module 'mini.extra'
local plugin = require('mini.extra')
plugin.setup({})

vim.keymap.set('n', '<leader>sa', plugin.pickers.manpages, { desc = 'Search man pages' })
vim.keymap.set('n', '<leader>sc', plugin.pickers.commands, { desc = 'Search commands' })
vim.keymap.set('n', '<leader>sd', plugin.pickers.diagnostic, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>se', plugin.pickers.explorer, { desc = 'Search explorer' })
vim.keymap.set('n', '<leader>sk', plugin.pickers.keymaps, { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader>sm', plugin.pickers.marks, { desc = 'Search marks' })
vim.keymap.set('n', '<leader>so', function()
  local mini_pick = require('mini.pick')
  plugin.pickers.oldfiles({}, {
    source = {
      match = function(stritems, inds, query)
        local matches = mini_pick.default_match(stritems, inds, query, { sync = true }) or {}
        return vim.tbl_filter(function(i) return not stritems[i]:lower():match('commit_editmsg$') end, matches)
      end,
    },
  })
end, { desc = 'Search old files' })
vim.keymap.set('n', '<leader>sR', plugin.pickers.registers, { desc = 'Search registers' })
vim.keymap.set('n', '<leader>sx', plugin.pickers.history, { desc = 'Search command history' })
