return {
  'MeanderingProgrammer/render-markdown.nvim',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}
