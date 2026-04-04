local p = require('my.packin')

-- dependencies = {
--   "nvim-lua/plenary.nvim", -- required
--   "sindrets/diffview.nvim", -- optional
--   "ibhagwan/fzf-lua", -- optional
-- },

p.add{
  src = 'https://github.com/NeogitOrg/neogit',
  cond = not vim.opt.diff:get(),
  after_load = function()
    vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', {desc = 'Show Neogit'})
  end
}
