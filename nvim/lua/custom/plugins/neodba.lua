local plugin_dir = vim.uv.os_homedir() .. '/code/neodba.nvim'

local ft = 'sql'

return {
  'neodba',
  cond = vim.uv.fs_stat(plugin_dir) and (not vim.opt.diff:get() and not nvtmux_auto_started()),
  config = true,
  dir = plugin_dir,
  ft = ft,
  keys = {
    {'<C-CR>', '<CMD>NeodbaExecSql<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Execute SQL'},
    {'<C-CR>', '<C-O><CMD>NeodbaExecSql<CR>', mode = 'i', ft = ft, desc = 'Neodba - Execute SQL'},
    {'<localleader>dm', '<CMD>NeodbaGetDatabaseInfo<CR>', mode = 'n', ft = ft, desc = 'Neodba - Get database info'},
    {'<localleader>dc', '<CMD>NeodbaGetColumnInfo<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Get column info'},
    {'<localleader>ds', '<CMD>NeodbaGetSchemas<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Get all schemas'},
    {'<localleader>dt', '<CMD>NeodbaGetTables<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Get all tables'},
    {'<localleader>dv', '<CMD>NeodbaGetViews<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Get all views'},
    {'<localleader>df', '<CMD>NeodbaGetFunctions<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Get all functions'},
    {'<localleader>dp', '<CMD>NeodbaGetProcedures<CR>', mode = {'n', 'v'}, ft = ft, desc = 'Neodba - Get all procedures'},
  },
}
