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


local function set_term_opts()
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.signcolumn = 'no'
  vim.cmd.colorscheme 'catppuccin-mocha'
  vim.opt.laststatus = 0
end


local function unset_term_opts()
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.signcolumn = 'yes'
  vim.cmd.colorscheme 'catppuccin-latte'
  vim.opt.laststatus = 2
end


local function plain_term()
  set_term_opts()
  vim.cmd('terminal')
  vim.cmd('startinsert')

  --[[ TODO: check if terminal is also last window before closing
  vim.api.nvim_create_autocmd('TermClose', {
    desc = 'Close Neovim when terminal is exited',
    pattern = '*',
    group = augroup,
    command = ':q'
  }) ]]
end


local function init()
  if is_enabled() then
    plain_term()
  end

  vim.api.nvim_create_user_command(
    'PlainTerm',
    plain_term,
    {bang = true,
     desc = 'Start plain terminal mode'})
end


return {
  doc = doc,
  init = init,
  is_enabled = is_enabled,
  plain_term = plain_term,
}
