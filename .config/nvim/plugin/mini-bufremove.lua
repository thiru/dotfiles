local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/nvim-mini/mini.bufremove',
  enabled = not u.diff_mode(),
  opts = {
    silent = true,
  },
  after_load = function(plugin)
    vim.keymap.set('n', '<leader>d', plugin.wipeout, {desc = 'Delete buffer'})
    vim.keymap.set('n', '<leader>D',
      function() plugin.wipeout(0, true) end,
      {desc = 'Delete buffer (ignore unsaved changes)'})
  end
}
