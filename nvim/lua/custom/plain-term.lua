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
  local bufferline_setup_spec = {
    options = vim.tbl_extend(
      'error',
      {mode = 'tabs'},
      require('custom.plugins.bufferline').opts.options)
  }
  require('bufferline').setup(bufferline_setup_spec)
end


local function is_term_open()
  local listed_buffers = vim.fn.getbufinfo({buflisted = 1})

  for _, v in pairs(listed_buffers) do
    if v.variables.terminal_job_id ~= nil then
      return true
    end
  end

  return false
end


local function plain_term()
  set_term_opts()
  vim.cmd('terminal')
  vim.cmd('startinsert')

  vim.api.nvim_create_autocmd('TermClose', {
    callback = function()
      -- If we've come into another terminal ensure we're in insert mode
      if vim.fn.mode() == 't' then
        vim.api.nvim_input('i')
      end

      -- Exit if no there are no more terminals open
      if not is_term_open() then
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
  is_term_open = is_term_open,
  plain_term = plain_term,
}
