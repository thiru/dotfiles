local p = require('my.packin')

p.add{
  src = 'https://github.com/nvim-mini/mini-git',
  name = 'mini.git',
  opts = {},
  after_load = function()
    vim.keymap.set({'n', 'v'}, '<leader>G', ':Git ', {desc = 'mini-git prompt'})
  end
}
