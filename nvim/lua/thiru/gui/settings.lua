local doc = 'Settings for Neovim GUIs'

local function setup()
  vim.opt.guifont = {'Fira Mono', ':h15'}
end

return {
  doc = doc,
  setup = setup
}
