local u = require('config.utils')

return {
  'MeanderingProgrammer/render-markdown.nvim',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  dependencies = {'nvim-treesitter/nvim-treesitter'}, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}
