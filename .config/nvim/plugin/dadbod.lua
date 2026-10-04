local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({'https://github.com/tpope/vim-dadbod'})
vim.pack.add({'https://github.com/kristijanhusak/vim-dadbod-ui'})
vim.pack.add({'https://github.com/kristijanhusak/vim-dadbod-completion'})

local function exec_sql_visual()
  -- We need to escape visual mode as the '< and '> marks apply to the *last* visual mode selection
  vim.cmd('normal! \27') -- ESC

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local end_line = end_pos[2]

  local cmd = ('%d,%dDB'):format(math.min(start_line, end_line), math.max(start_line, end_line))

  vim.cmd(cmd)
end

local function exec_sql_normal()
  local orig_cur_pos = vim.fn.getpos('.')

  vim.cmd('normal! vip')
  vim.cmd('normal! \27') -- ESC

  vim.fn.setpos('.', orig_cur_pos)

  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  local cmd = ('%d,%dDB'):format(math.min(start_line, end_line), math.max(start_line, end_line))

  vim.cmd(cmd)
end

local group = vim.api.nvim_create_augroup('dadbod_keybinds', {clear = true})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'sql',
  callback = function()
    vim.keymap.set('n', '<CR>', exec_sql_normal, { desc = 'Execute SQL (paragraph)' })
    vim.keymap.set('v', '<CR>', exec_sql_visual, { desc = 'Execute SQL (selected lines)' })
  end,
})
