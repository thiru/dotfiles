---@module 'mini.extra'

return {
  'nvim-mini/mini.extra',
  cond = not vim.opt.diff:get(),
  version = false,
  opts = {},
  keys = {
    { '<leader>sc', function() MiniExtra.pickers.commands() end, desc = 'Search Commands' },
    { '<leader>sd', function() MiniExtra.pickers.diagnostic() end, desc = 'Search Diagnostics' },
    { '<leader>se', function() MiniExtra.pickers.registers() end, desc = 'Search Registers' },
    { '<leader>sgb', function() MiniExtra.pickers.git_branches() end, desc = 'Search Git Branches' },
    { '<leader>sgc', function() MiniExtra.pickers.git_commits() end, desc = 'Search Git Commits' },
    { '<leader>sgf', function() MiniExtra.pickers.git_files() end, desc = 'Search Git Files' },
    { '<leader>sgh', function() MiniExtra.pickers.git_hunks() end, desc = 'Search Git Hunks' },
    { '<leader>sk', function() MiniExtra.pickers.keymaps() end, desc = 'Search Keymaps' },
    { '<leader>sm', function() MiniExtra.pickers.marks() end, desc = 'Search Marks' },
    { '<leader>so', function() MiniExtra.pickers.explorer({cwd=vim.uv.os_homedir()}) end, desc = 'Search/Open Path' },
    { '<leader>sr', function() MiniExtra.pickers.oldfiles() end, desc = 'Search Recent Files' },
    { '<leader>sx', function() MiniExtra.pickers.history() end, desc = 'Search Command History' },
  }
}
