return {
  'airblade/vim-rooter',
  enabled = function()
    return not vim.opt.diff:get()
  end,
  config = function()
    vim.g.rooter_patterns = {'.git', '.stfolder'}
  end
}
