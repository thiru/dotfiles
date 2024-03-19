return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('oil').setup({
      vim.keymap.set('n', '<leader>o', ':Oil --float .<CR>', { desc = 'Open Oil in floating window' })
    })
  end
}
