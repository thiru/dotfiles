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

-- NOTE: we use fff in Windows
if not u.is_windows() then
  vim.keymap.set('n', '<leader>sf', plugin.builtin.files, { desc = 'Search files' })
  vim.keymap.set('n', '<leader>sp', plugin.builtin.grep_live, { desc = 'Search project' })
  vim.keymap.set('n', '<leader>sr', plugin.builtin.resume, { desc = 'Search resume' })
  vim.keymap.set('n', '<leader>sw',
    function()
      plugin.builtin.grep({ pattern = vim.fn.expand('<cword>'), method = 'plain' })
    end,
    { desc = 'Search word/selection' })
  vim.keymap.set('x', '<leader>sw',
    function()
      plugin.builtin.grep({ pattern = u.selected_text(), method = 'plain' })
    end,
    { desc = 'Search word/selection' })
  vim.keymap.set('n', '<leader>sv',
    function()
      plugin.builtin.files({}, { source = { cwd = vim.fn.stdpath('config') } })
    end,
    { desc = 'Search Neovim configs' })
end

vim.keymap.set('n', '<C-g>', function()
  plugin.start({
    source = {
      items = function()
        local dirs = vim.fn.systemlist("fd --follow --type directory --hidden --max-depth 4 . $HOME")
        -- Prefer git repositories (directories containing a .git subdirectory)
        local repos, rest = {}, {}
        for _, dir in ipairs(dirs) do
          table.insert(vim.uv.fs_stat(dir .. '/.git') and repos or rest, dir)
        end
        return vim.list_extend(repos, rest)
      end,
      name = 'Goto -> ',
      choose = function(item)
        vim.cmd('tcd ' .. vim.fn.fnameescape(item))
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
        vim.cmd('tcd ' .. vim.fn.fnameescape(item))
      end,
    },
  })
end, {desc = 'Change directory (relative to CWD)'})
