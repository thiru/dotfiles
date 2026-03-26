return {
  'airblade/vim-rooter',
  cond = not vim.opt.diff:get(),
  lazy = false,
  config = function()
    vim.g.rooter_patterns = {'deps.edn', 'package.json', '.git', '.stfolder', '.rooter'}
    vim.g.rooter_silent_chdir = true
  end
}
