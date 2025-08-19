local u = require('config.utils')

return {
  'airblade/vim-rooter',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  lazy = false,
  config = function()
    vim.g.rooter_patterns = {'deps.edn', '.git', '.stfolder', '.forced-root'}
  end
}
