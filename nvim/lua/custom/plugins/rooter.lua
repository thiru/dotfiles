return {
  'airblade/vim-rooter',
  cond = not vim.opt.diff:get() and not require('custom.plain-term').is_enabled(),
  config = function()
    vim.g.rooter_patterns = {'.git', '.stfolder'}
  end
}
