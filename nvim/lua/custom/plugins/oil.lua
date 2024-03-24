return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('oil').setup({
      keymaps = {
        ['<ESC>'] = 'actions.close'
      },
      float = {
        max_width = 100,
        max_height = 23
      }
    })
    vim.keymap.set('n', '<leader>o', ':Oil --float .<CR>', { desc = 'Open Oil in floating window (at CWD)' })
    vim.keymap.set('n', '<leader>O', ':Oil --float %:p:h<CR>', { desc = 'Open Oil in floating window (at parent dir of current file)' })
  end
}
