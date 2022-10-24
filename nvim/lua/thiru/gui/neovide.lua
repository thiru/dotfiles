local doc = 'Neovide-specific configs'

local transparency_default = 0.9
local transparency_step = 0.05

local function transparency_print()
  print('Neovide transparency = ' .. vim.g.neovide_transparency)
end

local function transparency_reset()
  vim.g.neovide_transparency = transparency_default
  transparency_print()
end

local function transparency_dec()
  vim.g.neovide_transparency = math.min(vim.g.neovide_transparency + transparency_step, 1)
  transparency_print()
end

local function transparency_inc()
  vim.g.neovide_transparency = math.max(vim.g.neovide_transparency - transparency_step, 0)
  transparency_print()
end

local function setup()
  if not vim.g.neovide then
    return
  end

  vim.g.neovide_transparency = transparency_default

  vim.api.nvim_create_user_command(
    'NeovideTransparencyInc',
    transparency_inc,
    {bang = true, desc = 'Increment Neovide transparency'}
  )

  vim.api.nvim_create_user_command(
    'NeovideTransparencyDec',
    transparency_dec,
    {bang = true, desc = 'Decrement Neovide transparency'}
  )

  vim.api.nvim_create_user_command(
    'NeovideTransparencyReset',
    transparency_reset,
    {bang = true, desc = 'Reset Neovide transparency to default setting'}
  )

  vim.keymap.set({'i', 'n', 't', 'v'}, "<A-=>", "<cmd>:NeovideTransparencyInc<CR>")
  vim.keymap.set({'i', 'n', 't', 'v'}, "<A-->", "<cmd>:NeovideTransparencyDec<CR>")
  vim.keymap.set({'i', 'n', 't', 'v'}, "<A-0>", "<cmd>:NeovideTransparencyReset<CR>")
end

return {
  doc = doc,
  setup = setup,
  transparency_dec = transparency_dec,
  transparency_default = transparency_default,
  transparency_inc = transparency_inc,
  transparency_print = transparency_print,
  transparency_reset = transparency_reset,
}
