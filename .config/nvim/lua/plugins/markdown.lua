return {
  'MeanderingProgrammer/render-markdown.nvim',
  cond = not vim.opt.diff:get(),
  dependencies = {'nvim-treesitter/nvim-treesitter'}, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}
