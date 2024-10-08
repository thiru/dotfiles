return {
  "OXY2DEV/markview.nvim",
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  lazy = false, -- Recommended
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  opts = {
    list_items = {
      indent_size = 2,
      shift_width = 2,
    }
  }
}
