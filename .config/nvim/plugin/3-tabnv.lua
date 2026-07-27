local neovide = require('my.neovide')

local local_add_ok, _ = pcall(vim.cmd.packadd, 'tabnv.nvim')

if not local_add_ok then
  vim.pack.add({{
    name = 'tabnv',
    src = 'https://github.com/thiru/tabnv.nvim',
  }})
end

require('tabnv').setup({
  colorscheme = 'catppuccin-mocha',
  neovide_opacity = neovide.terminal_opacity_override,
})
