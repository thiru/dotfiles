local options = require('custom.options')

return {
  'ktunprasert/gui-font-resize.nvim',
  config = function()
    vim.opt.guifont = {'Fira Mono', ':h' .. options.font_size_default}
    require("gui-font-resize").setup()
    vim.keymap.set({'i', 'n', 't', 'v'},
                   '<C-=>',
                   '<cmd>:GUIFontSizeUp<CR>',
                   { desc = 'Increase GUI font size' })

    vim.keymap.set({'i', 'n', 't', 'v'},
                   '<C-->',
                   '<cmd>:GUIFontSizeDown<CR>',
                   { desc = 'Decrease GUI font size' })

    vim.keymap.set({'i', 'n', 't', 'v'},
                   '<C-0>',
                   '<cmd>:GUIFontSizeSet ' .. options.font_size_default .. '<CR>',
                   { desc = 'Reset GUI font size to default value (' .. options.font_size_default .. ')' })
  end
}
