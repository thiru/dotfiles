vim.pack.add({{
  name = 'catppuccin',
  src = 'https://github.com/catppuccin/nvim',
}})

require('catppuccin').setup({
  flavour = 'latte',
  term_colors = true,
})

vim.cmd.colorscheme('catppuccin-nvim')
