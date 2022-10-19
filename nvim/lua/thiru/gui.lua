local doc = 'Config for Neovim GUIs'

local plain_term = require('thiru.plain-term')

local function general()
  vim.opt.guifont = {'Fira Mono', ':h15'}
end

local function neovide()
  if not vim.g.neovide then
    return
  end

  if plain_term.is_enabled() then
    vim.g.neovide_transparency = 0.80
  else
    vim.g.neovide_transparency = 0.95
  end
end

local function setup()
  general()
  neovide()
end

return {
  doc = doc,
  general = general,
  neovide = neovide,
  setup = setup
}
