local u = require('mine.utils')
local tnvws = require('tabnv.workspace')

local function is_non_terminal_buffer()
  return vim.bo.buftype ~= 'terminal'
end

local function show_winbar()
  return is_non_terminal_buffer()
end

--- Update a terminal buffer's term:// name when its shell reports a new cwd via OSC 7.
--- This is used to keep the git branch lualine component up-to-date.
local function update_terminal_name_from_osc7(ev)
  local buf = ev.buf
  if vim.bo[buf].buftype ~= 'terminal' then
    return
  end

  local uri = ev.data.sequence:match('\027%]7;(.*)')
  if not uri then
    return
  end
  uri = uri:gsub('\007$', ''):gsub('\027\\$', '')

  local path = uri:match('^file://[^/]*(/.*)$')
  if not path then
    return
  end

  local ok, cwd = pcall(vim.uri_to_fname, 'file://' .. path)
  if not ok or vim.fn.isdirectory(cwd) ~= 1 then
    return
  end

  local name = vim.api.nvim_buf_get_name(buf)
  local suffix = name:match('^term://.-(//.*)$')
  if not suffix then
    return
  end

  local new_name = 'term://' .. cwd .. suffix
  if new_name == name then
    return
  end

  vim.api.nvim_buf_set_name(buf, new_name)

  -- Lualine normally re-detects the Git directory on BufEnter. Re-detect now
  -- as well when this terminal is already active.
  if vim.api.nvim_get_current_buf() == buf then
    local ok, branch = pcall(require, 'lualine.components.branch.git_branch')
    if ok then
      branch.find_git_dir()
    end
    require('lualine').refresh()
  end
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
    section_separators = '',
  },

  -- Tabline
  tabline = {
    lualine_a = {
      tnvws.tabline_workspaces,
    },
    lualine_b = {
      { tnvws.get_active_workspace_name, separator = { right = '' } },
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
      {u.get_cwd, color='ErrorMsg'},
      {u.get_file_parent, cond=is_non_terminal_buffer, color='Directory'},
    },
    lualine_b = {
    },
    lualine_c = {
    },
    lualine_x = {
      'selectioncount',
      'searchcount',
    },
    lualine_y = {
      {buffer_location, color='Directory'},
    },
    lualine_z = {
      {'branch'},
    },
  }
})

vim.api.nvim_create_autocmd('TermRequest', {
  group = vim.api.nvim_create_augroup('lualine_termrequest_osc7', { clear = true }),
  desc = 'Update terminal buffer name from OSC 7 cwd',
  callback = update_terminal_name_from_osc7,
})
