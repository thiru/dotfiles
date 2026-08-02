local u = require('mine.utils')

if u.diff_mode() then return end

local local_dir = vim.fn.stdpath("config") .. '/pack/mine/opt/neodba.nvim'

if vim.fn.isdirectory(local_dir) == 1 then
  vim.cmd.packadd('neodba.nvim')
else
  vim.pack.add({{
    name = 'neodba',
    src = 'https://github.com/thiru/neodba.nvim',
  }})
end

require('neodba').setup({
  -- HACK: these hooks are used to work around the RenderMarkdown plugin failing to correctly
  -- render the output table after being updated.
  pre_hook = function() vim.cmd('RenderMarkdown disable') end,
  post_hook = function() vim.cmd('RenderMarkdown enable') end,
})
