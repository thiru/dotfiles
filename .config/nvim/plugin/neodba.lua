local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/thiru/neodba.nvim',
  dev_src = '~/code/neodba.nvim',
  name = 'neodba',
  enabled = false,--not u.diff_mode(),
  opts = {
    -- HACK: these hooks are used to work around the RenderMarkdown plugin failing to correctly
    -- render the output table after being updated.
    pre_hook = function() vim.cmd('RenderMarkdown disable') end,
    post_hook = function() vim.cmd('RenderMarkdown enable') end,
  },
}
