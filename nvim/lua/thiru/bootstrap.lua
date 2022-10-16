local doc = 'Auto-install packer and plugins on fresh install.'

local u = require('thiru.utils')

local packer_install_dir = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local restart_notice = [[
===============================================================================
                     Packer & plugins are being installed
            Please wait until Packer completes then restart Neovim
                      (safe to ignore errors for now)
===============================================================================
]]

local function is_packer_installed()
  return u.is_path_present(packer_install_dir)
end

local function install_packer()
  vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. packer_install_dir)
  vim.cmd('packadd packer.nvim')
end

local function setup(register_plugins)
  local is_new_install = not is_packer_installed()

  if is_new_install then
    install_packer()
  end

  local packer = require('packer')

  packer.startup(register_plugins)

  if is_new_install then
    packer.sync()
    print(restart_notice)
  end

  return is_new_install
end

return {
  doc = doc,
  install_packer = install_packer,
  is_packer_installed = is_packer_installed,
  setup = setup
}
