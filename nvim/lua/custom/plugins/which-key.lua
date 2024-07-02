local top_margin = (vim.fn.winheight(0) / 2) - 5

return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    window = {
      border = 'single',
      margin = {top_margin, 10, 0, 10},
      position = 'top',
      winblend = 20,
    },
    layout = {
      align = 'center',
    },
    triggers_nowait = {
      '`', -- marks
      '<C-a>', -- nvtmux
    }
  }
}
