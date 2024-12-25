local doc = 'Common utilities.'

-- [[ Detect if we're running Windows. ]]
function _G.is_windows()
  return vim.fn.has('win64') ~= 0
end


-- [[ Pretty-print lua values including tables. ]]
function _G.pp(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end


-- [[ Check whether at least the given version of glibc is present. ]]
function _G.has_glibc_version(min_major, min_minor)
  -- print('Requiring glibc: ' .. min_major .. '.' .. min_minor) -- DEBUG
  local handle = io.popen('ldd --version')
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

--- Get visually selected characters on current line
local function selected_text_in_visual_char_mode()
  local orig_cur_pos = vim.fn.getpos('.')

  -- We need to escape visual mode as the '< and '> marks apply to the *last* visual mode selection
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), 'x', true)

  vim.fn.setpos('.', orig_cur_pos)

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local end_line = end_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_col = end_pos[3]

  local sel_lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})

  local sel_text_joined = vim.trim(table.concat(sel_lines, ' '))

  return sel_text_joined
end

--- Get visually selected lines
local function selected_text_in_visual_line_mode()
  local orig_cur_pos = vim.fn.getpos('.')

  -- We need to escape visual mode as the '< and '> marks apply to the *last* visual mode selection
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), 'x', true)

  vim.fn.setpos('.', orig_cur_pos)

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = math.max(0, start_pos[2] - 1)
  local end_line = end_pos[2]
  local sel_lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

  local sel_text_joined = vim.trim(table.concat(sel_lines, ' '))

  return sel_text_joined
end

--- Get visually selected text (char-wise or line-wise)
function _G.selected_text()
  local mode = vim.fn.mode()

  if mode == 'V' then
    return selected_text_in_visual_line_mode()
  else
    return selected_text_in_visual_char_mode()
  end
end


function _G.nvtmux_auto_started()
  return vim.g.nvtmux_auto_start == true
end

return {
  doc = doc,
}
