return {
  'airblade/vim-rooter',
  cond = not vim.opt.diff:get(),
  lazy = false,
  config = function()
    vim.g.rooter_patterns = {'deps.edn', '.git', '.stfolder', '.forced-root'}
  end
}
