return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    preset = 'modern',
    triggers = {
      { "<auto>", mode = "nixsotc" },
    }
  }
}
