if require('my.utils').diff_mode() then return end

vim.pack.add({'https://github.com/nvim-lua/plenary.nvim'})

vim.pack.add({{
  name = 'curl',
  src = 'https://github.com/oysandvik94/curl.nvim',
}})

require('curl').setup({
  default_flags = {'--insecure'},
  show_request_duration_limit = 0.5,
})
