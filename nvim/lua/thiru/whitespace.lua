local doc = 'Generic functions around dealing with whitespace characters'

local function line_endings_as_dos()
  vim.cmd([[
    edit ++ff=dos
    write
  ]])
end

local function line_endings_as_unix()
  vim.cmd([[
    edit ++ff=dos
    setlocal ff=unix
    write
  ]])
end

local function strip_trailing_whitespace()
  vim.cmd(':%s/\\s\\+$//e')
end

local function setup()
  vim.api.nvim_create_user_command(
    'LineEndingsAsDos',
    line_endings_as_dos,
    {bang = true,
     desc = 'Convert line endings in current file to DOS format'})

  vim.api.nvim_create_user_command(
    'LineEndingsAsUnix',
    line_endings_as_unix,
    {bang = true,
     desc = 'Convert line endings in current file to Unix format'})

  vim.api.nvim_create_user_command(
    'StripTrailingWhitespace',
    strip_trailing_whitespace,
    {bang = true,
     desc = 'Strip trailing whitespace chars in current buffer'})
end

return {
  doc = doc,
  line_endings_as_dos = line_endings_as_dos,
  line_endings_as_unix = line_endings_as_unix,
  setup = setup,
  strip_trailing_whitespace = strip_trailing_whitespace
}
