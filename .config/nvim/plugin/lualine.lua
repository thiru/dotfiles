local u = require('mine.utils')
local tnvws = require('tabnv.workspace')

local function is_terminal_buffer()
  return vim.bo.buftype == 'terminal'
end

local function is_non_terminal_buffer()
  return vim.bo.buftype ~= 'terminal'
end

local function show_winbar()
  return is_non_terminal_buffer()
end

--- Get git branch for terminal.
--- This is set externally (currently from a fish trigger)
local function term_branch()
  local tabdir_ok, tabdir = pcall(vim.api.nvim_tabpage_get_var, 0, 'tabbranch')
  if tabdir_ok and tabdir and #tabdir > 0 then
    return ' ' .. tabdir
  end
  return ''
end

--- Get the location in the buffer.
--- I.e. line | column | current line percentage
local function buffer_location()
  if vim.fn.mode():find("t") then
    return ''
  else
    return '%{printf("%d:%d|%d%%", line("."), col("."), float2nr(100.0 * line(".") / line("$")))}'
  end
end

-- deps: {'nvim-tree/nvim-web-devicons'},
vim.pack.add({'https://github.com/nvim-lualine/lualine.nvim'})

local plugin = require('lualine')

plugin.setup({
  -- Global options
  options = {
    always_show_tabline = false,
    disabled_filetypes = {
      winbar = {'aerial', 'DiffviewFileHistory'}
    },
    icons_enabled = true,
    component_separators = '',
    globalstatus = true,
    refresh = {
      refresh_time = 150
    },
    section_separators = '',
  },

  -- Tabline
  tabline = {
    lualine_a = {
      tnvws.tabline_workspaces,
    },
    lualine_z = {
      { tnvws.tabline_tabs, padding = { left = 0, right = 0 } }
    },
  },

  -- Winbar
  winbar = {
    lualine_c = {
      {
        'buffers',
        cond = show_winbar,
        symbols = {
          alternate_file = '',
        },
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      {'filename', cond=show_winbar, path=0},
    },
  },

  -- Statusline
  sections = {
    lualine_a = {
      {'branch', cond=is_non_terminal_buffer},
      {term_branch, cond=is_terminal_buffer},
    },
    lualine_b = {
    },
    lualine_c = {
      '%=',
      {u.get_cwd, color='ErrorMsg'},
      {u.get_file_parent, cond=is_non_terminal_buffer, color='Directory'},
    },
    lualine_x = {
    },
    lualine_y = {
      'selectioncount',
      'searchcount',
    },
    lualine_z = {
      {buffer_location, color='Directory'},
    },
  }
})
