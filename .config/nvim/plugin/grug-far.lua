if require('my.utils').diff_mode() then return end

vim.pack.add({{
  name = 'grug-far',
  src = 'https://github.com/MagicDuck/grug-far.nvim',
}})

require('grug-far').setup()

vim.keymap.set('n',  '<leader>S', '<CMD>GrugFar<CR>', {desc = 'Search and Replace'})
