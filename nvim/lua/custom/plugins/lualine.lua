local function replace_home_with_tilde(path)
  local home_dir = vim.loop.os_homedir() or ''
  if vim.startswith(path, home_dir) then
    return '~' .. string.sub(path, #home_dir + 1)
  else
    return path
  end
end

local function get_cwd()
  return ' ' .. replace_home_with_tilde(vim.fn.getcwd())
end

local function get_file_path()
  local abs_path = vim.api.nvim_buf_get_name(0) or ''

  if #abs_path == 0 then
    return ''
  end

  local cwd = vim.fn.getcwd()
  local final_path = ' '

  if not vim.startswith(abs_path, cwd) then
    final_path = final_path .. abs_path
  else
    final_path = final_path .. string.sub(abs_path, #cwd + 2)
  end

  return replace_home_with_tilde(final_path)
end

return {
  'nvim-lualine/lualine.nvim',
  helpers = {
    get_cwd = get_cwd,
    get_file_path = get_file_path,
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
        get_file_path,
      },
      lualine_c = {
        'fileformat',
        'encoding',
        'filesize',
      },
      lualine_x = {'diagnostics', 'branch'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
}
