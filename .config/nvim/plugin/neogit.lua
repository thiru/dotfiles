local p = require('my.packin')
local u = require('my.utils')

-- dependencies = {
--   "nvim-lua/plenary.nvim", -- required
--   "sindrets/diffview.nvim", -- optional
--   "ibhagwan/fzf-lua", -- optional
-- },

p.add{
  src = 'https://github.com/NeogitOrg/neogit',
  enabled = not u.diff_mode(),
  after_load = function()
    vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', {desc = 'Show Neogit'})
  end
}
