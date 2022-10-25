local doc = [[
  Emulate a typical terminal (i.e. with minimal vim interface elements).

  Use by starting Neovim like so:
  ```
  nvim --cmd 'lua vim.g.plain_term = true'
  ```
  ]]

local plugin_settings = require('thiru.settings.plugins')

local augroup = vim.api.nvim_create_augroup('plain-term', {clear = true})

local function is_enabled()
  return vim.g.plain_term == true
end

local function set_term_opts()
  vim.opt.cursorcolumn = false
  vim.opt.laststatus = 0
  vim.opt.number = false
  vim.opt.signcolumn = 'no'
  plugin_settings.colour_scheme_dark()
end

local function unset_term_opts()
  vim.opt.cursorcolumn = true
  vim.opt.laststatus = 2
  vim.opt.number = true
  vim.opt.signcolumn = 'yes'
  plugin_settings.colour_scheme_light()
  plugin_settings.lualine()
end

local function plain_term()
  set_term_opts()
  vim.cmd('terminal')
  vim.cmd('startinsert')

  -- TODO: check if terminal is also last window before closing
  vim.api.nvim_create_autocmd('TermClose', {
    desc = 'Close Neovim when terminal is exited',
    pattern = '*',
    group = augroup,
    command = ':q'
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'Switch between plain-term and regular mode',
    pattern = '*',
    group = augroup,
    callback = function()
      if vim.bo.buftype == 'terminal' then
        set_term_opts()
      elseif vim.bo.buftype == '' or vim.bo.buftype == nil then
        unset_term_opts()
      end
    end
  })
end

local function setup()
  if is_enabled() then
    plain_term()
  end
end

return {
  doc = doc,
  is_enabled = is_enabled,
  plain_term = plain_term,
  setup = setup
}
