return {
  'akinsho/bufferline.nvim',
  cond = not nvtmux_auto_started(),
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  opts = {
    options = {
      always_show_bufferline = false,
    }
  }
}
