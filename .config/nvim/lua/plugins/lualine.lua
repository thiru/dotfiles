local u = require('config.utils')

local function is_term()
  return vim.bo.buftype == 'terminal'
end

local function is_not_term()
  return vim.bo.buftype ~= 'terminal'
end

local function show_winbar()
  return is_not_term() and #vim.api.nvim_list_bufs() > 1
end

--- Only show first character of the mode to save screen real estate.
local function shortened_mode(mode)
  return mode:sub(1,1)
end

--- Get git branch for terminal
local function term_branch()
  local tabdir_ok, tabdir = pcall(vim.api.nvim_tabpage_get_var, 0, 'tabbranch')
  return tabdir_ok and tabdir or ''
end

return {
  'nvim-lualine/lualine.nvim',
  cond = not u.is_kitty_scrollback(),
  dependencies = {'nvim-tree/nvim-web-devicons'},
  opts = {
    options = {
      always_show_tabline = false,
      icons_enabled = true,
      component_separators = '',
      globalstatus = true,
      refresh = {
        refresh_time = 100
      },
      section_separators = '',
      theme = 'catppuccin-nvim',
    },
    tabline = {
      lualine_a = {
      },
      lualine_b = {
      },
      lualine_c = {
      },
      lualine_x = {
      },
      lualine_y = {
      },
      lualine_z = {
        {'tabs', tabs_color={active='lualine_a_visual', inactive='lualine_b_visual'}, max_length=1000, mode=2, tab_max_length=10}
      },
    },
    winbar = {
      lualine_b = {
        {'buffers', cond=show_winbar, mode=2},
      },
    },
    inactive_winbar = {
      lualine_b = {
        {'buffers', cond=show_winbar, mode=2},
      },
    },
    sections = {
      lualine_a = {
      },
      lualine_b = {
        {u.get_cwd, icon='🏡'},
        {u.get_file_parent, cond=is_not_term, icon='📂', padding={left=0, right=1}},
      },
      lualine_c = {
        {'branch', cond=is_not_term},
        {term_branch, cond=is_term, icon=''},
      },
      lualine_x = {
      },
      lualine_y = {
        {'diagnostics', cond=is_not_term},
        {'lsp_status', cond=is_not_term},
        -- {'fileformat', cond=is_not_term},
        -- {'encoding', cond=is_not_term},
        {'filesize', cond=is_not_term},
      },
      lualine_z = {
        {'location', cond=is_not_term},
        {'progress', cond=is_not_term},
      },
    },
  }
}
