return {
  'gcmt/taboo.vim',
  cond = nvtmux_auto_started(),
  config = function()
    vim.g.taboo_tab_format = ' %I %f '
    vim.g.taboo_renamed_tab_format = ' %I %l '
  end
}

