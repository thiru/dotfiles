return {
  "ibhagwan/fzf-lua",
  cond = not vim.opt.diff:get(),
  dependencies = { "nvim-mini/mini.icons" },
  lazy = false,
  config = function()
    local fzf = require("fzf-lua")
    local config = fzf.config
    local actions = fzf.actions

    config.defaults.actions.files['enter'] = actions.file_edit
    config.defaults.actions.files['ctrl-q'] = actions.file_sel_to_qf
  end,
  keys = {
    { '<leader>sa', '<CMD>FzfLua manpages<CR>', desc = 'Search Manpages' },
    { '<leader>sb', '<CMD>FzfLua buffers<CR>', desc = 'Search Buffers' },
    { '<leader>sc', '<CMD>FzfLua commands<CR>', desc = 'Search Commands' },
    { '<leader>sdd', '<CMD>FzfLua diagnostics_document<CR>', desc = 'Search Document Diagnostics' },
    { '<leader>sdw', '<CMD>FzfLua diagnostics_workspace<CR>', desc = 'Search Worspace Diagnostics' },
    { '<leader>sf', '<CMD>FzfLua files<CR>', desc = 'Search Files' },
    { '<leader>sgb', '<CMD>FzfLua git_branches<CR>', desc = 'Search Git Branches' },
    { '<leader>sgc', '<CMD>FzfLua git_bcommits<CR>', desc = 'Search Git Commits (Buffer)' },
    { '<leader>sgf', '<CMD>FzfLua git_files<CR>', desc = 'Search Git Files' },
    { '<leader>sgh', '<CMD>FzfLua git_hunks<CR>', desc = 'Search Git Hunks' },
    { '<leader>sgl', '<CMD>FzfLua git_commits<CR>', desc = 'Search Git Commits (Project)' },
    { '<leader>sh', '<CMD>FzfLua helptags<CR>', desc = 'Search Help' },
    { '<leader>sj', '<CMD>FzfLua jumps<CR>', desc = 'Search Jumps' },
    { '<leader>sk', '<CMD>FzfLua keymaps<CR>', desc = 'Search Keymaps' },
    { '<leader>sl', '<CMD>FzfLua lsp_references<CR>', desc = 'Search LSP references' },
    { '<leader>sm', '<CMD>FzfLua marks<CR>', desc = 'Search Marks' },
    { '<leader>so', '<CMD>FzfLua oldfiles<CR>', desc = 'Search Recent Files' },
    { '<leader>sr', '<CMD>FzfLua registers<CR>', desc = 'Search Registers' },
    { '<leader>sR', '<CMD>FzfLua resume<CR>', desc = 'Resume latest picker' },
    { '<leader>ss', '<CMD>FzfLua grep_visual<CR>', desc = 'Search visual selection', mode='v' },
    { '<leader>st', '<CMD>FzfLua live_grep_native<CR>', desc = 'Search Text (live)' },
    { '<leader>sv', function() require('fzf-lua').files({cwd=vim.fn.stdpath('config')}) end, desc = 'Search Vim Configs' },
    { '<leader>sw', '<CMD>FzfLua grep_cword<CR>', desc = 'Search word under cursor' },
    { '<leader>sW', '<CMD>FzfLua grep_cWORD<CR>', desc = 'Search WORD under cursor' },
    { '<leader>sx', '<CMD>FzfLua command_history<CR>', desc = 'Search Command History' },
  },
}
