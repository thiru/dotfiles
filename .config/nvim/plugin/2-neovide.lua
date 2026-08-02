--- Neovide config
---
--- NOTE: there are no vim.pack calls here
--- This is used merely to setup Neovide including adding some user commands and keymaps

local u = require('mine.utils')

local opacity_step = 0.05
local scale_factor_delta_default = 1.025

local function print_opacity()
  print('Neovide opacity = ' .. vim.g.neovide_opacity)
end

local function set_default_opacity()
  if vim.tbl_contains(vim.v.argv, '+TabnvStart') then
    vim.g.neovide_opacity = u.terminal_opacity_override
  else
    vim.g.neovide_opacity = u.opacity_default
  end
end

local function reset_opacity()
  set_default_opacity()
  print_opacity()
end

local function inc_opacity()
  vim.g.neovide_opacity = math.min(vim.g.neovide_opacity + opacity_step, 1)
  print_opacity()
end

local function dec_opacity()
  vim.g.neovide_opacity = math.max(vim.g.neovide_opacity - opacity_step, 0)
  print_opacity()
end

local function scale_factor_update(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

local function scale_factor_reset()
  vim.g.neovide_scale_factor = 1.0
end

if vim.g.neovide then
  vim.cmd('silent exe "cd ~"')
  vim.g.neovide_scale_factor = 1.0
  set_default_opacity()
end

vim.api.nvim_create_user_command(
  'NeovideOpacityDec',
  dec_opacity,
  {bang = true, desc = 'Decrement Neovide opacity'}
)

vim.api.nvim_create_user_command(
  'NeovideOpacityInc',
  inc_opacity,
  {bang = true, desc = 'Increment Neovide opacity'}
)

vim.api.nvim_create_user_command(
  'NeovideOpacityReset',
  reset_opacity,
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
