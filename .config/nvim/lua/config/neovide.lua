local u = require('config.utils')
local doc = 'Neovide-specific configs'

local opacity_default = 1.0
local opacity_step = 0.05
local terminal_opacity_override = u.is_windows() and 1.0 or 0.95
local scale_factor_delta_default = 1.1

local function opacity_print()
  print('Neovide opacity = ' .. vim.g.neovide_opacity)
end

local function set_default_opacity()
  if u.nvtmux_auto_started() then
    vim.g.neovide_opacity = terminal_opacity_override
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

local function scale_factor_update(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

local function scale_factor_reset()
  vim.g.neovide_scale_factor = 1.0
end

local function init()
  if vim.g.neovide then
    vim.cmd('silent exe "cd ~"')
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_scale_factor = 1.0
    set_default_opacity()
  end

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

  -- Opacity
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-=>', '<cmd>:NeovideOpacityInc<CR>', {desc='Increase opacity'})
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-->', '<cmd>:NeovideOpacityDec<CR>', {desc='Decrease opacity'})
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-0>', '<cmd>:NeovideOpacityReset<CR>', {desc='Reset opacity'})

  -- Scale Factor
  vim.keymap.set({'i', 'n', 't', 'v'}, '<C-=>', function() scale_factor_update(scale_factor_delta_default) end, {desc='Increase scale factor'})
  vim.keymap.set({'i', 'n', 't', 'v'}, '<C-->', function() scale_factor_update(1 / scale_factor_delta_default) end, {desc='Decrease scale factor'})
  vim.keymap.set({'i', 'n', 't', 'v'}, '<C-0>', scale_factor_reset, {desc='Reset scale factor'})
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
