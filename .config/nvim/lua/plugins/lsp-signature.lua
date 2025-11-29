return {
  'ray-x/lsp_signature.nvim',
  cond = not vim.opt.diff:get(),
  event = 'InsertEnter',
  opts = {},
}
