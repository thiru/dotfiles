local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({'https://github.com/nvim-mini/mini.completion'})

local plugin = require('mini.completion')
plugin.setup({
  delay = { completion = 500, info = 100, signature = 50 },
})

-- Additional custom mappings:
local imap_expr = function(lhs, rhs)
  vim.keymap.set('i', lhs, rhs, { expr = true })
end
imap_expr('<C-j>', [[pumvisible() ? "\<C-n>" : "\<C-j>"]])
imap_expr('<C-k>', [[pumvisible() ? "\<C-p>" : "\<C-k>"]])
imap_expr('<TAB>', [[pumvisible() ? "\<C-y>" : "\<TAB>"]])

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'fff_input', 'snacks_picker_input' },
  callback = function()
      vim.b.minicompletion_disable = true
    end
})
