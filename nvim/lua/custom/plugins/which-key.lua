return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    layout = {
      align = 'center',
    },
    triggers = {
      { "<auto>", mode = "nixsotc" },
      { '<C-a>' } -- for nvtmux
    }
  }
}
