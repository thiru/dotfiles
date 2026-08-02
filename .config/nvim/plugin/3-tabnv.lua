local u = require('mine.utils')

local local_dir = vim.fn.stdpath("config") .. '/pack/mine/opt/tabnv.nvim'

if vim.fn.isdirectory(local_dir) == 1 then
  vim.cmd.packadd('tabnv.nvim')
else
  vim.pack.add({{
    name = 'tabnv',
    src = 'https://github.com/thiru/tabnv.nvim',
  }})
end

require('tabnv').setup({
  colorscheme = 'catppuccin-mocha',
  neovide_opacity = u.terminal_opacity_override,
})
