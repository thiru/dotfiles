local doc = 'Auto-install the lazy package manager and plugins on fresh install.'

local lazy_install_dir = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

local function setup()
  if not vim.loop.fs_stat(lazy_install_dir) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_install_dir,
    })
  end
  vim.opt.rtp:prepend(lazy_install_dir)
end

return {
  doc = doc,
  setup = setup
}
