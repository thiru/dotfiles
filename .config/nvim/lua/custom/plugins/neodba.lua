local u = require('custom.utils')

return {
  'thiru/neodba.nvim',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  dev = true,
  ft = 'sql',
  opts = {
    -- HACK: these hooks are used to work around the RenderMarkdown plugin failing to correctly
    -- render the output table after being updated.
    pre_hook = function() vim.cmd('RenderMarkdown disable') end,
    post_hook = function() vim.cmd('RenderMarkdown enable') end,
  },
}
