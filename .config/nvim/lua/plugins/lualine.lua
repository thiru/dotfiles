local u = require('config.utils')

local function replace_home_with_tilde(path)
  local home_dir = vim.uv.os_homedir() or ''
  if vim.startswith(path, home_dir) then
    return '~' .. string.sub(path, #home_dir + 1)
  else
    return path
  end
end

local function get_cwd()
  return ' ' .. replace_home_with_tilde(vim.fn.getcwd()) .. '/'
end

local function get_file_parent_and_name()
  local abs_path = vim.api.nvim_buf_get_name(0) or ''

  if #abs_path == 0 then
    return ''
  end

  local cwd = vim.fn.getcwd()
  local final_path = ''

  if not vim.startswith(abs_path, cwd) then
    final_path = final_path .. abs_path
  else
    final_path = final_path .. string.sub(abs_path, #cwd + 2)
  end

  local parent_dir = ''
  for dir in vim.fs.parents(final_path) do
    parent_dir = dir
    break
  end

  if #parent_dir == 0 or parent_dir == '.' then
    local filename = string.sub(final_path, #parent_dir)
    return filename
  end

  local filename = string.sub(final_path, #parent_dir + math.min(#parent_dir, 2))
  parent_dir = replace_home_with_tilde(parent_dir) .. '/'

  return parent_dir .. ' | ' .. filename
end

return {
  'nvim-lualine/lualine.nvim',
  cond = not u.nvtmux_auto_started() and not u.is_kitty_scrollback(),
  helpers = {
    get_cwd = get_cwd,
    get_file_parent_and_name = get_file_parent_and_name,
    replace_home_with_tilde = replace_home_with_tilde,
  },
  opts = {
    options = {
      icons_enabled = true,
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {
        get_cwd,
        get_file_parent_and_name,
      },
      lualine_c = {},
      lualine_x = {
        'fileformat',
        'encoding',
        'filesize',
      },
      lualine_y = {'diagnostics', 'branch'},
      lualine_z = {'progress', 'location'}
    },
  }
}
