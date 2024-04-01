return {
  'preservim/tagbar',
  enabled = function()
    return not vim.opt.diff:get()
  end,
  config = function()
    vim.keymap.set('n', '<leader>ta', ':TagbarToggle<CR>', { desc = '' })
  end
}
