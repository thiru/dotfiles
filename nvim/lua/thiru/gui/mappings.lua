local doc = 'Key mappings for Neovim GUIs'

local function setup()
  vim.keymap.set('n', '<C-=>', '<cmd>:GUIFontSizeUp<CR>')
  vim.keymap.set('n', '<C-->', '<cmd>:GUIFontSizeDown<CR>')
  vim.keymap.set('n', '<C-0>', '<cmd>:GUIFontSizeSet 15<CR>')
end

return {
  doc = doc,
  setup = setup
}
