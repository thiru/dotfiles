local p = require('my.packin')
local u = require('my.utils')

-- deps: {'nvim-tree/nvim-web-devicons'},

local function is_term()
  return vim.bo.buftype == 'terminal'
end

local function is_not_term()
  return vim.bo.buftype ~= 'terminal'
end

local function show_winbar()
  return is_not_term()
end

--- Get git branch for terminal
local function term_branch()
  local tabdir_ok, tabdir = pcall(vim.api.nvim_tabpage_get_var, 0, 'tabbranch')
  return tabdir_ok and tabdir or ''
end

p.add{
  src = 'https://github.com/nvim-lualine/lualine.nvim',
  name = 'lualine',
  opts = {
    options = {
      always_show_tabline = false,
      disabled_filetypes = {
        winbar = {'aerial', 'DiffviewFileHistory'}
      },
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
        {
          'buffers',
          cond = show_winbar,
          mode = 2,
          symbols = {alternate_file = ''}},
      },
    },
    inactive_winbar = {
      lualine_b = {
        {'filename', cond=show_winbar, path=0},
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
