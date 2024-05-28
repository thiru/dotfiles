local plugin_dir = vim.loop.os_homedir() .. '/code/neodba.nvim'

local ft = 'sql'

return {
  'neodba',
  enabled = function()
    return vim.loop.fs_stat(plugin_dir)
  end,
  config = true,
  dir = plugin_dir,
  ft = ft,
  keys = {
    {'<C-CR>', '<CMD>NeodbaExecSql<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Execute SQL'},
    {'<C-CR>', '<C-O><CMD>NeodbaExecSql<CR>', mode = 'i', ft = ft, desc = 'Neodba - Execute SQL'},
    {'<localleader>dm', '<CMD>NeodbaGetDatabaseInfo<CR>', mode = 'n', ft = ft, desc = 'Neodba - Get database info'},
    {'<localleader>dc', '<CMD>NeodbaGetColumnInfo<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Get column info'},
  },
}
