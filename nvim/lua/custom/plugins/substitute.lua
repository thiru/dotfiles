local u = require('custom.utils')

return {
  'gbprod/substitute.nvim',
  cond = not u.nvtmux_auto_started(),
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local substitute = require('substitute')

    substitute.setup()

    vim.keymap.set('n', '<leader>p', substitute.operator, { desc = 'Substitute with motion' })
    vim.keymap.set('n', '<leader>pp', substitute.line, { desc = 'Substitute line' })
    vim.keymap.set('n', '<leader>pP', substitute.eol, { desc = 'Substitute to end of line' })
    vim.keymap.set('x', '<leader>p', substitute.visual, { desc = 'Substitute in visual mode' })
  end,
}
