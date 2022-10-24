local doc = 'Neovide-specific configs'

local function setup()
  if vim.g.neovide then
    vim.g.neovide_transparency = 0.90
  end
end

return {
  doc = doc,
  setup = setup
}
