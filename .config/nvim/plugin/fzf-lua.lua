local p = require('my.packin')

-- deps: { "nvim-mini/mini.icons" },

p.add{
  src = 'https://github.com/ibhagwan/fzf-lua',
  name = 'fzf-lua',
  cond = not vim.opt.diff:get(),
  lazy = false,
  after_load = function(plugin)
    local config = plugin.config
    local actions = plugin.actions

    config.defaults.actions.files['enter'] = actions.file_edit
    config.defaults.actions.files['ctrl-q'] = actions.file_sel_to_qf

    vim.keymap.set('n', '<leader>sa', '<CMD>FzfLua manpages<CR>', {desc = 'Search Manpages'})
    vim.keymap.set('n', '<leader>sb', '<CMD>FzfLua lgrep_curbuf<CR>', {desc = 'Search Current Buffer'})
    vim.keymap.set('n', '<leader>sc', '<CMD>FzfLua commands<CR>', {desc = 'Search Commands'})
    vim.keymap.set('n', '<leader>sdd', '<CMD>FzfLua diagnostics_document<CR>', {desc = 'Search Document Diagnostics'})
    vim.keymap.set('n', '<leader>sdw', '<CMD>FzfLua diagnostics_workspace<CR>', {desc = 'Search Worspace Diagnostics'})
    vim.keymap.set('n', '<leader>sf', '<CMD>FzfLua files<CR>', {desc = 'Search Files'})
    vim.keymap.set('n', '<leader>sgb', '<CMD>FzfLua git_branches<CR>', {desc = 'Search Git Branches'})
    vim.keymap.set('n', '<leader>sgc', '<CMD>FzfLua git_bcommits<CR>', {desc = 'Search Git Commits (Buffer)'})
    vim.keymap.set('n', '<leader>sgf', '<CMD>FzfLua git_files<CR>', {desc = 'Search Git Files'})
    vim.keymap.set('n', '<leader>sgh', '<CMD>FzfLua git_hunks<CR>', {desc = 'Search Git Hunks'})
    vim.keymap.set('n', '<leader>sgl', '<CMD>FzfLua git_commits<CR>', {desc = 'Search Git Commits (Project)'})
    vim.keymap.set('n', '<leader>sh', '<CMD>FzfLua helptags<CR>', {desc = 'Search Help'})
    vim.keymap.set('n', '<leader>sj', '<CMD>FzfLua jumps<CR>', {desc = 'Search Jumps'})
    vim.keymap.set('n', '<leader>sk', '<CMD>FzfLua keymaps<CR>', {desc = 'Search Keymaps'})
    vim.keymap.set('n', '<leader>sl', '<CMD>FzfLua lsp_references<CR>', {desc = 'Search LSP references'})
    vim.keymap.set('n', '<leader>sm', '<CMD>FzfLua marks<CR>', {desc = 'Search Marks'})
    vim.keymap.set('n', '<leader>so', '<CMD>FzfLua oldfiles<CR>', {desc = 'Search Recent Files'})
    vim.keymap.set('n', '<leader>sr', '<CMD>FzfLua registers<CR>', {desc = 'Search Registers' })
    vim.keymap.set('n', '<leader>sR', '<CMD>FzfLua resume<CR>', {desc = 'Resume latest picker' })
    vim.keymap.set('v', '<leader>ss', '<CMD>FzfLua grep_visual<CR>', {desc = 'Search visual selection'})
    vim.keymap.set('n', '<leader>sp',
      function()
        plugin.live_grep_native({rg_opts="--hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e"})
      end,
      {desc = 'Search Entire Project'})
    vim.keymap.set('n', '<leader>sv',
      function()
        plugin.files({cwd=vim.fn.stdpath('config')})
      end, {desc = 'Search Vim Configs'})
    vim.keymap.set('n', '<leader>sw', '<CMD>FzfLua grep_cword<CR>', {desc = 'Search word under cursor'})
    vim.keymap.set('n', '<leader>sW', '<CMD>FzfLua grep_cWORD<CR>', {desc = 'Search WORD under cursor'})
    vim.keymap.set('n', '<leader>sx', '<CMD>FzfLua command_history<CR>', {desc = 'Search Command History'})
    vim.keymap.set('n', '<C-g>',
      function()
        plugin.fzf_exec("fd --follow --type directory . $HOME", {
          prompt = "Goto -> ",
          actions = {
            ['default'] = function(selected)
              vim.cmd("cd " .. selected[1])
            end
          },
        })
      end,
      {desc = 'Change directory (home)'})
    vim.keymap.set('n', '<C-h>',
      function()
        plugin.fzf_exec("fd --follow --type directory .", {
          prompt = "Goto -> ",
          actions = {
            ['default'] = function(selected)
              vim.cmd("cd " .. selected[1])
            end
          },
        })
      end,
      {desc = 'Change directory (relative)'})
  end
}
