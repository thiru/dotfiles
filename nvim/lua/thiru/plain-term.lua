local doc = [[
  Emulate a typical terminal (i.e. with minimal vim interface elements).

  Use by starting Neovim like so:
  ```
  nvim --cmd 'lua vim.g.plain_term = true'
  ```
  ]]

local augroup = vim.api.nvim_create_augroup('plain-term', {clear = true})

local function is_enabled()
  return vim.g.plain_term == true
end

-- Show relative numbers when not within/editing the terminal - e.g. normal mode
local function relativenumber_autocmds()
  vim.api.nvim_create_autocmd('TermEnter', {
    pattern = '*',
    group = augroup,
    callback = function()
      vim.opt.relativenumber = false
    end
  })

  vim.api.nvim_create_autocmd('TermLeave', {
    pattern = '*',
    group = augroup,
    callback = function()
      vim.opt.relativenumber = true
    end
  })
end

local function plain_term()
  relativenumber_autocmds()

  vim.api.nvim_create_autocmd('TermClose', {
    pattern = '*',
    group = augroup,
    command = ':q'
  })

  vim.opt.background = 'dark'
  vim.opt.bufhidden = 'hide'
  vim.opt.cursorcolumn = false
  vim.opt.cursorline = false
  vim.opt.laststatus = 0
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.showmode = true
  vim.opt.showtabline = 0
  vim.cmd('terminal')
  vim.cmd('startinsert')
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
