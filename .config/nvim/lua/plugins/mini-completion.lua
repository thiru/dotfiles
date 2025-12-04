return {
  'nvim-mini/mini.completion',
  cond = not vim.opt.diff:get(),
  version = false,
  config = function()
    require('mini.completion').setup({})

    -- Additional custom mappings:
    local imap_expr = function(lhs, rhs)
      vim.keymap.set('i', lhs, rhs, { expr = true })
    end
    imap_expr('<C-j>',   [[pumvisible() ? "\<C-n>" : "\<C-j>"]])
    imap_expr('<C-k>', [[pumvisible() ? "\<C-p>" : "\<C-k>"]])
    imap_expr('<TAB>', [[pumvisible() ? "\<C-y>" : "\<TAB>"]])

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'snacks_picker_input' },
      callback = function()
          vim.b.minicompletion_disable = true
        end
    })
  end
}
