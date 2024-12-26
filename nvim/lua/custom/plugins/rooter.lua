local u = require('custom.utils')

return {
  'airblade/vim-rooter',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  config = function()
    vim.g.rooter_patterns = {'.git', '.stfolder'}
  end
}
