return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    local toggleterm = require('toggleterm')
    toggleterm.setup({
      direction = 'vertical',
      open_mapping = [[<c-t>]],
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
    })
    vim.keymap.set('n', '<leader>tl', ':ToggleTermSendCurrentLine<CR>', { desc = 'Sent current line to terminal' })
    vim.keymap.set('v', '<leader>tl', ':ToggleTermSendVisualLines<CR>', { desc = 'Sent visual lines to terminal' })
    vim.keymap.set('v', '<leader>ts', ':ToggleTermSendVisualSelection<CR>', { desc = 'Sent visual selection to terminal' })
  end
}
