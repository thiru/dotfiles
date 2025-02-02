local u = require('custom.utils')
local doc = 'Neovide-specific configs'

local transparency_default = 1.0
local transparency_step = 0.05
local term_trans_override = 0.95
if u.is_windows() then
  term_trans_override = 1.0
end

local function transparency_print()
  print('Neovide transparency = ' .. vim.g.neovide_transparency)
end

local function set_default_transparency()
  if u.nvtmux_auto_started() then
    vim.g.neovide_transparency = term_trans_override
  else
    vim.g.neovide_transparency = transparency_default
  end
end

local function transparency_reset()
  set_default_transparency()
  transparency_print()
end

local function transparency_inc()
  vim.g.neovide_transparency = math.min(vim.g.neovide_transparency + transparency_step, 1)
  transparency_print()
end

local function transparency_dec()
  vim.g.neovide_transparency = math.max(vim.g.neovide_transparency - transparency_step, 0)
  transparency_print()
end

local function init()
  if not vim.g.neovide then
    return
  end

  vim.cmd('silent exe "cd ~"')
  vim.g.neovide_hide_mouse_when_typing = true
  set_default_transparency()

  vim.api.nvim_create_user_command(
    'NeovideTransparencyDec',
    transparency_dec,
    {bang = true, desc = 'Decrement Neovide transparency'}
  )

  vim.api.nvim_create_user_command(
    'NeovideTransparencyInc',
    transparency_inc,
    {bang = true, desc = 'Increment Neovide transparency'}
  )

  vim.api.nvim_create_user_command(
    'NeovideTransparencyReset',
    transparency_reset,
    {bang = true, desc = 'Reset Neovide transparency to default setting'}
  )

  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-=>', '<cmd>:NeovideTransparencyInc<CR>')
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-->', '<cmd>:NeovideTransparencyDec<CR>')
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-0>', '<cmd>:NeovideTransparencyReset<CR>')
end

return {
  doc = doc,
  init = init,
  transparency_inc = transparency_inc,
  transparency_default = transparency_default,
  transparency_dec = transparency_dec,
  transparency_print = transparency_print,
  transparency_reset = transparency_reset,
}
