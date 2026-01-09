local u = require('config.utils')

local function is_term()
  return vim.bo.buftype == 'terminal'
end

local function is_not_term()
  return vim.bo.buftype ~= 'terminal'
end

-- Only show first character of the mode to save screen real estate.
local function shortened_mode(mode)
  return mode:sub(1,1)
end

-- Show the CWD and the parent dirs as two segments.
local function cwd_and_parent_dirs()
  local parent_dir = u.get_file_parent()
  local cwd = u.get_cwd()

  local segments = {'🏠'}

  if #cwd > 0 and cwd ~= '~' then
    table.insert(segments, cwd)
  end

  if #parent_dir > 0 then
    table.insert(segments, '➔ ' .. parent_dir)
  end

  return table.concat(segments, ' ')
end

return {
  'nvim-lualine/lualine.nvim',
  cond = not u.is_kitty_scrollback(),
  dependencies = {'nvim-tree/nvim-web-devicons'},
  opts = {
    options = {
      always_show_tabline = true,
      icons_enabled = true,
      component_separators = '|',
      globalstatus = true,
      section_separators = '',
      theme = 'catppuccin',
    },
    tabline = {
      lualine_a = {
        {'mode', fmt=shortened_mode},
      },
      lualine_b = {
        {'buffers', cond=is_not_term, separator={left='', right=''}, mode=2},
      },
      lualine_c = {
      },
      lualine_x = {
      },
      lualine_y = {
      },
      lualine_z = {
        {'tabs', separator={left='', right=''}, max_length=1000, mode=2, tab_max_length=10}
      },
    },
    sections = {
      lualine_a = {
        {cwd_and_parent_dirs, cond=is_not_term},
        {u.get_cwd, cond=is_term},
      },
      lualine_b = {
        {'branch', cond=is_not_term},
      },
      lualine_c = {
      },
      lualine_x = {
      },
      lualine_y = {
        {'diagnostics', cond=is_not_term},
        {'lsp_status', cond=is_not_term},
        {'fileformat', cond=is_not_term},
        {'encoding', cond=is_not_term},
        {'filesize', cond=is_not_term},
      },
      lualine_z = {
        {'location', cond=is_not_term},
        {'progress', cond=is_not_term},
      },
    },
  }
}
