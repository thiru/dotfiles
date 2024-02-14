return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'kyazdani42/nvim-web-devicons'
  },
  config = function()
    require("bufferline").setup({
      options = {
        always_show_bufferline = false,
        show_buffer_icons = false
      }
    })
  end
}
