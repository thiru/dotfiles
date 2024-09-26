return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    triggers = {
      { "<auto>", mode = "nixsotc" },
    }
  }
}
