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

local function plain_term()
  vim.api.nvim_create_autocmd('TermClose', {
    desc = 'Close Neovim when terminal is exited',
    pattern = '*',
    group = augroup,
    command = ':q'
  })

  vim.opt.cursorcolumn = false
  vim.opt.laststatus = 0
  vim.opt.number = false
  vim.opt.signcolumn = 'no'
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
