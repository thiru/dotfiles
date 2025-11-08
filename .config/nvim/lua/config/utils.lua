local h = require('config.utils_helpers')

local M = {
  doc = 'Common utilities.'
}

-- Get path with home directory replaced with tilde.
function M.replace_home_with_tilde(path)
  local home_dir = vim.uv.os_homedir() or ''
  if vim.startswith(path, home_dir) then
    return '~' .. string.sub(path, #home_dir + 1)
  else
    return path
  end
end

--- Get the current working directory (using tilde for home dir).
function M.get_cwd()
  return M.replace_home_with_tilde(vim.fn.getcwd())
end

-- Get name of file's parent dir.
function M.get_file_parent()
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
    return ''
  end

  parent_dir = M.replace_home_with_tilde(parent_dir) .. '/'

  return parent_dir
end

--- Detect if we're running Windows.
function M.is_windows()
  return vim.fn.has('win64') ~= 0
end

--- Check whether at least the given version of glibc is present.
function M.has_glibc_version(min_major, min_minor)
  -- vim.print('Requiring glibc: ' .. min_major .. '.' .. min_minor) -- DEBUG
  local handle = io.popen('ldd --version')
  if handle == nil then
    return false
  end

  local result = handle:read('*a')
  handle:close()

  local major, minor = result:match('(%d+)%.(%d+)')
  major = tonumber(major)
  minor = tonumber(minor)
  -- print('Detected glibc version: ' .. major .. '.' .. minor) -- DEBUG

  if major < min_major then
    return false
  elseif major == min_major then
    return minor >= min_minor
  end

  return true
end

--- Get visually selected text (char-wise or line-wise)
function M.selected_text()
  local mode = vim.fn.mode()

  if mode == 'V' then
    return h.selected_text_in_visual_line_mode()
  else
    return h.selected_text_in_visual_char_mode()
  end
end

--- Get visually selected text (char-wise or line-wise) if any, otherwise the current line.
function M.get_selected_text_or_current_line()
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' then
    return M.selected_text()
  else
    return vim.fn.getline('.')
  end
end

--- Check if Nvtmux plugin auto-start was requested.
function M.nvtmux_auto_started()
  return vim.g.nvtmux_auto_start == true
end

--- Check if we're being called as a Kitty scrollback buffer
function M.is_kitty_scrollback()
  return vim.g.kitty_scrollback == true
end

return M
