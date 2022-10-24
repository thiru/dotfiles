local doc = 'Key mappings for Neovim GUIs'

local gui_settings = require('thiru.gui.settings')

local function setup()
  vim.keymap.set('n', '<C-=>', '<cmd>:GUIFontSizeUp<CR>',
                 { desc = 'Increase GUI font size' })
  vim.keymap.set('n', '<C-->', '<cmd>:GUIFontSizeDown<CR>',
                 { desc = 'Decrease GUI font size' })
  vim.keymap.set('n', '<C-0>', '<cmd>:GUIFontSizeSet ' .. gui_settings.font_size_default .. '<CR>',
                 { desc = 'Reset GUI font size to default value (' .. gui_settings.font_size_default .. ')' })
end

return {
  doc = doc,
  setup = setup
}
