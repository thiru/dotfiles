vim.pack.add({{
  name = 'catppuccin',
  src = 'https://github.com/catppuccin/nvim',
}})

require('catppuccin').setup({
  auto_integrations = true,
  flavour = 'latte',
  term_colors = true,
})

vim.cmd.colorscheme('catppuccin-nvim')
