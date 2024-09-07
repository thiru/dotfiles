return {
  'MeanderingProgrammer/render-markdown.nvim',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  opts = {},
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}
