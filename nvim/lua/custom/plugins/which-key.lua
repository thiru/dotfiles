return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    layout = {
      align = 'center',
    },
    modes = {
      defer = {
        ['<C-a>'] = false, -- for nvtmux
      }
    }
  }
}
