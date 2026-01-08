local u = require('config.utils')

local M = {
  opacity_default = 1.0,
  opacity_step = 0.05,
  terminal_opacity_override = u.is_windows() and 1.0 or 0.95,
  scale_factor_delta_default = 1.1,
}

function M.opacity_print()
  print('Neovide opacity = ' .. vim.g.neovide_opacity)
end

function M.set_default_opacity()
  if u.nvtmux_auto_started() then
    vim.g.neovide_opacity = M.terminal_opacity_override
  else
    vim.g.neovide_opacity = M.opacity_default
  end
end

function M.opacity_reset()
  M.set_default_opacity()
  M.opacity_print()
end

function M.opacity_inc()
  vim.g.neovide_opacity = math.min(vim.g.neovide_opacity + M.opacity_step, 1)
  M.opacity_print()
end

function M.opacity_dec()
  vim.g.neovide_opacity = math.max(vim.g.neovide_opacity - M.opacity_step, 0)
  M.opacity_print()
end

function M.scale_factor_update(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

function M.scale_factor_reset()
  vim.g.neovide_scale_factor = 1.0
end

function M.init()
  if vim.g.neovide then
    vim.cmd('silent exe "cd ~"')
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_scale_factor = 1.0
    M.set_default_opacity()
  end

  vim.api.nvim_create_user_command(
    'NeovideOpacityDec',
    M.opacity_dec,
    {bang = true, desc = 'Decrement Neovide opacity'}
  )

  vim.api.nvim_create_user_command(
    'NeovideOpacityInc',
    M.opacity_inc,
    {bang = true, desc = 'Increment Neovide opacity'}
  )

  vim.api.nvim_create_user_command(
    'NeovideOpacityReset',
    M.opacity_reset,
    {bang = true, desc = 'Reset Neovide opacity to default setting'}
  )

  -- Opacity
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-=>', '<cmd>:NeovideOpacityInc<CR>', {desc='Increase opacity'})
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-->', '<cmd>:NeovideOpacityDec<CR>', {desc='Decrease opacity'})
  vim.keymap.set({'i', 'n', 't', 'v'}, '<A-0>', '<cmd>:NeovideOpacityReset<CR>', {desc='Reset opacity'})

  -- Scale Factor
  vim.keymap.set({'i', 'n', 't', 'v'}, '<C-=>', function() M.scale_factor_update(M.scale_factor_delta_default) end, {desc='Increase scale factor'})
  vim.keymap.set({'i', 'n', 't', 'v'}, '<C-->', function() M.scale_factor_update(1 / M.scale_factor_delta_default) end, {desc='Decrease scale factor'})
  vim.keymap.set({'i', 'n', 't', 'v'}, '<C-0>', M.scale_factor_reset, {desc='Reset scale factor'})
end

return M
