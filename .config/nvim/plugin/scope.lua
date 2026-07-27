if require('my.utils').diff_mode() then return end

vim.pack.add({{
  name = 'scope',
  src = 'https://github.com/tiagovla/scope.nvim',
}})

require('scope').setup()
