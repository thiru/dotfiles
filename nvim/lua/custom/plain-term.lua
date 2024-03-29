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
  vim.opt.cursorline = false
  vim.opt.scrolloff = 0
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.signcolumn = 'no'
  vim.cmd.colorscheme 'catppuccin-mocha'
  vim.opt.laststatus = 0
end


local function plain_term()
  set_term_opts()
  vim.cmd('terminal')
  vim.cmd('startinsert')

  vim.api.nvim_create_autocmd('TermClose', {
    callback = function()
      -- HACK: Bypass the 'Process exited' message:
      vim.api.nvim_input('<CR>')

      -- If we've come into another terminal ensure we're in insert mode
      if vim.fn.mode() == 't' then
        vim.api.nvim_input('i')
      end

      -- HACK: Not sure why there is a difference between OS' here:
      local min_bufs_to_exit = is_windows() and 1 or 2

      -- Account for the initial empty buffer as well I guess
      if #vim.api.nvim_list_bufs() <= min_bufs_to_exit then
        vim.cmd(':q')
      end
    end,
    group = augroup,
    pattern = '*',
  })
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
