local u = require('custom.utils')

return {
  'akinsho/bufferline.nvim',
  cond = not u.nvtmux_auto_started(),
  event = 'VeryLazy',
  keys = {
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
    { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
    { '<C-j>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<C-k>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '<leader>bj', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
    { '<leader>bk', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
  },
  opts = {
    options = {
      always_show_bufferline = true,
    }
  }
}
