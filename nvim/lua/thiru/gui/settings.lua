local doc = 'Settings for Neovim GUIs'

local font_size_default = 15

local function setup()
  vim.opt.guifont = {'Fira Mono', ':h' .. font_size_default}
end

return {
  doc = doc,
  font_size_default = font_size_default,
  setup = setup
}
