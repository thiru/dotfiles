if require('my.utils').diff_mode() then return end

-- NOTE deps: 'nvim-treesitter/nvim-treesitter' (if you prefer nvim-web-devicons)

vim.pack.add({{
  name = 'render-markdown',
  src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}})
