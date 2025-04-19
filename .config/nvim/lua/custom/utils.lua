local h = require('custom.utils_helpers')

local M = {
  doc = 'Common utilities.'
}

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
