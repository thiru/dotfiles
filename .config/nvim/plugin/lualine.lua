local p = require('my.packin')
local u = require('my.utils')

-- deps: {'nvim-tree/nvim-web-devicons'},

local function is_term()
  return vim.bo.buftype == 'terminal'
end

local function is_not_term()
  return vim.bo.buftype ~= 'terminal'
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
        {'filesize', cond=is_not_term},
      },
      lualine_z = {
        {'location', cond=is_not_term},
        {'progress', cond=is_not_term},
      },
    },
  }
}
