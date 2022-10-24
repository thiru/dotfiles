local doc = 'Config for Neovim GUIs'

local function general()
  vim.opt.guifont = {'Fira Mono', ':h15'}
end

local function neovide()
  if vim.g.neovide then
    vim.g.neovide_transparency = 0.90
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
