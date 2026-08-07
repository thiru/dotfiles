vim.pack.add({{
  name = 'rose-pine',
  src = 'https://github.com/rose-pine/neovim',
}})

local plugin = require('rose-pine')
plugin.setup({
  dark_variant = 'moon',
})

vim.cmd.colorscheme('rose-pine')
