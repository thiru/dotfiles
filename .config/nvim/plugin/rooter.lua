local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({{
  name = 'rooter',
  src = 'https://github.com/wsdjeg/rooter.nvim',
}})

local plugin = require('rooter')

plugin.setup({
  command = 'tcd',
  root_patterns = { '.git/' },
})

plugin.disable()

-- NOTE: disabling this plugin by default due to some undesired behaviour
-- around new tabs and switching dirs.

vim.keymap.set('n', '<leader>cd',
  function()
    plugin.enable()
    plugin.current_root()
    plugin.disable()
  end,
  {desc='Go to project root', silent=true})
