local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({'https://github.com/nvim-mini/mini.pick'})

---@module 'mini.pick'
local plugin = require('mini.pick')
plugin.setup({
  mappings = {
    choose_marked = '<C-CR>',
    mark = '<Tab>',
    move_down = '<C-j>',
    move_start = '<C-g>',
    move_up = '<C-k>',
    paste = '<C-S-v>',
    toggle_preview = '<C-Tab>',
  }
})

vim.keymap.set('n', '<leader>sb', plugin.builtin.buffers, {desc = 'Search buffers'})
vim.keymap.set('n', '<leader>sh', plugin.builtin.help, {desc = 'Search help'})

vim.keymap.set('n', '<C-g>', function()
  plugin.start({
    source = {
      items = function()
        return vim.fn.systemlist("fd --follow --type directory --hidden --max-depth 4 . $HOME")
      end,
      name = 'Goto -> ',
      choose = function(item)
        vim.cmd('cd ' .. vim.fn.fnameescape(item))
      end,
    },
  })
end, {desc = 'Change directory (from $HOME)'})

vim.keymap.set('n', '<leader><C-g>', function()
  plugin.start({
    source = {
      items = function()
        return vim.fn.systemlist("fd --follow --type directory --hidden .")
      end,
      name = 'Goto -> ',
      choose = function(item)
        vim.cmd('cd ' .. vim.fn.fnameescape(item))
      end,
    },
  })
end, {desc = 'Change directory (relative to CWD)'})
