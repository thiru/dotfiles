return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup({
      direction = 'vertical',
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
    })
    vim.keymap.set('n', '<C-t>', ':ToggleTerm dir=git_dir<CR>', { desc = 'Open toggle-term terminal'})
    vim.keymap.set('n', '<leader>tl', ':ToggleTermSendCurrentLine<CR>', { desc = 'Send current line to terminal' })
    vim.keymap.set('v', '<leader>tl', ':ToggleTermSendVisualLines<CR>', { desc = 'Send visual lines to terminal' })
    vim.keymap.set('v', '<leader>ts', ':ToggleTermSendVisualSelection<CR>', { desc = 'Send visual selection to terminal' })
  end
}
