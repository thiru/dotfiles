local u = require('mine.utils')

if u.diff_mode() then return end

vim.g.db_ui_execute_on_save = 0

vim.pack.add({'https://github.com/tpope/vim-dadbod'})
vim.pack.add({'https://github.com/kristijanhusak/vim-dadbod-ui'})
vim.pack.add({'https://github.com/kristijanhusak/vim-dadbod-completion'})

local dbui_execute_key = vim.api.nvim_replace_termcodes('<Plug>(DBUI_ExecuteQuery)', true, false, true)

local function execute_dbui_selection(win, view)
  local ok, err = pcall(vim.api.nvim_feedkeys, dbui_execute_key, 'mx', false)

  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    vim.fn.winrestview(view)
  end

  if not ok then error(err, 0) end
end

local function exec_sql_visual()
  local win = vim.api.nvim_get_current_win()
  local view = vim.fn.winsaveview()
  execute_dbui_selection(win, view)
end

local function exec_sql_normal()
  local win = vim.api.nvim_get_current_win()
  local view = vim.fn.winsaveview()
  vim.cmd('normal! vip')
  execute_dbui_selection(win, view)
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
