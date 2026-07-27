if require('my.utils').diff_mode() then return end

local local_add_ok, _ = pcall(vim.cmd.packadd, 'neodba.nvim')

if not local_add_ok then
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
