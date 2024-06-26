local doc = 'Plugin manager install, setup and 3rd-party plugin registration.'


-- [[ Install `lazy.nvim` plugin manager if not yet installed. ]]
local function install_lazy_nvim()
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
end


-- [[ Register 3rd-party plugins. ]]
local function register_plugins()
  require('lazy').setup({
    -- Auto-load plugins in the specified folder:
    { import = 'custom.plugins' }},
    {
      dev = {
        path = '~/code',
        fallback = true
      },
      change_detection = {enabled = false}
    })
end


return {
  doc = doc,
  install_lazy_nvim = install_lazy_nvim,
  register_plugins = register_plugins,
}
