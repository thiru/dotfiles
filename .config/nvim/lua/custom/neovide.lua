local u = require('custom.utils')
local doc = 'Neovide-specific configs'

local opacity_default = 1.0
local opacity_step = 0.05
local term_trans_override = 0.95
if u.is_windows() then
  term_trans_override = 1.0
end

local function opacity_print()
  print('Neovide opacity = ' .. vim.g.neovide_opacity)
end

local function set_default_opacity()
  if u.nvtmux_auto_started() then
    vim.g.neovide_opacity = term_trans_override
  else
    vim.g.neovide_opacity = opacity_default
  end
end

local function opacity_reset()
  set_default_opacity()
  opacity_print()
end

local function opacity_inc()
  vim.g.neovide_opacity = math.min(vim.g.neovide_opacity + opacity_step, 1)
  opacity_print()
end

local function opacity_dec()
  vim.g.neovide_opacity = math.max(vim.g.neovide_opacity - opacity_step, 0)
  opacity_print()
end

local function init()
  if not vim.g.neovide then
    return
  end

  vim.cmd('silent exe "cd ~"')
  vim.g.neovide_hide_mouse_when_typing = true
  set_default_opacity()

  vim.api.nvim_create_user_command(
    'NeovideOpacityDec',
    opacity_dec,
    {bang = true, desc = 'Decrement Neovide opacity'}
  )

  vim.api.nvim_create_user_command(
    'NeovideOpacityInc',
    opacity_inc,
    {bang = true, desc = 'Increment Neovide opacity'}
  )

  vim.api.nvim_create_user_command(
    'NeovideOpacityReset',
    opacity_reset,
    {bang = true, desc = 'Reset Neovide opacity to default setting'}
  )

  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-=>', '<cmd>:NeovideOpacityInc<CR>')
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-->', '<cmd>:NeovideOpacityDec<CR>')
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-0>', '<cmd>:NeovideOpacityReset<CR>')
end

return {
  doc = doc,
  init = init,
  opacity_inc = opacity_inc,
  opacity_default = opacity_default,
  opacity_dec = opacity_dec,
  opacity_print = opacity_print,
  opacity_reset = opacity_reset,
}
