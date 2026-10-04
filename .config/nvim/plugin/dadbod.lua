local u = require('mine.utils')

if u.diff_mode() then return end

vim.g.db_ui_execute_on_save = 0

vim.pack.add({'https://github.com/tpope/vim-dadbod'})
vim.pack.add({'https://github.com/kristijanhusak/vim-dadbod-ui'})
vim.pack.add({'https://github.com/kristijanhusak/vim-dadbod-completion'})

local dbui_execute_key = vim.api.nvim_replace_termcodes('<Plug>(DBUI_ExecuteQuery)', true, false, true)

local function execute_dbui_selection(orig_cur_pos)
  local ok, err = pcall(vim.api.nvim_feedkeys, dbui_execute_key, 'mx', false)
  vim.fn.setpos('.', orig_cur_pos)

  if not ok then error(err, 0) end
end

local function exec_sql_visual()
  local orig_cur_pos = vim.fn.getpos('.')
  execute_dbui_selection(orig_cur_pos)
end

local function exec_sql_normal()
  local orig_cur_pos = vim.fn.getpos('.')
  vim.cmd('normal! vip')
  execute_dbui_selection(orig_cur_pos)
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
