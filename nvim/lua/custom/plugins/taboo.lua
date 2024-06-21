return {
  'gcmt/taboo.vim',
  cond = nvtmux_auto_started(),
  config = function()
    vim.g.taboo_tab_format = ' %I %f '
  end
}

