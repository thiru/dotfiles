return {
  'preservim/tagbar',
  config = function()
    vim.keymap.set('n', '<leader>ta', ':TagbarToggle<CR>', { desc = '' })
  end
}
