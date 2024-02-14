return {
  'preservim/tagbar',
  config = function()
    vim.keymap.set('n', '<leader>t', ':TagbarToggle<CR>', { desc = '' })
  end
}
