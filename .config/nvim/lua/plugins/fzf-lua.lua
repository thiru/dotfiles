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
    { '<leader>sf', '<CMD>FzfLua files<CR>', desc = 'Search Files' },
    { '<leader>sr', '<CMD>FzfLua oldfiles<CR>', desc = 'Search Recent Files' },
  },
}
