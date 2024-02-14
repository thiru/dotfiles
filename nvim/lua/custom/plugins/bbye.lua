return {
 'moll/vim-bbye',
  config = function()
    -- Close buffer without also closing splits
    vim.keymap.set('n', '<leader>d', ':Bwipeout<CR>', { desc = 'Close buffer' })
    vim.keymap.set('n', '<leader>D', ':Bwipeout!<CR>', { desc = 'Close buffer (even if modified)' })
  end
}
