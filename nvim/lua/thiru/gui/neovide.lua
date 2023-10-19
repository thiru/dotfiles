local doc = 'Neovide-specific configs'

local plain_term = require('thiru.plain-term')

local transparency_default = 0.95
local transparency_step = 0.05
local term_trans_override = 0.85

local function transparency_print()
  print('Neovide transparency = ' .. vim.g.neovide_transparency)
end

local function set_default_transparency()
  if plain_term.is_enabled() then
    vim.g.neovide_transparency = term_trans_override
  else
    vim.g.neovide_transparency = transparency_default
  end
end

local function transparency_reset()
  set_default_transparency()
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

  -- Start in home directory so it's easier to search entire directory tree
  vim.cmd('cd ~')

  -- HACK: Neovide exits terminal mode when mouse is moved
  -- See: https://github.com/neovide/neovide/issues/1838
  vim.keymap.set("t", "<MouseMove>", "<NOP>")

  set_default_transparency()

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
