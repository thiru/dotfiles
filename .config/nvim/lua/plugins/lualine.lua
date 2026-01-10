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

return {
  'nvim-lualine/lualine.nvim',
  cond = not u.is_kitty_scrollback(),
  dependencies = {'nvim-tree/nvim-web-devicons'},
  opts = {
    options = {
      always_show_tabline = true,
      icons_enabled = true,
      component_separators = '',
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
      },
      lualine_b = {
        {u.get_cwd, icon='🏡'},
        {u.get_file_parent, cond=is_not_term, icon='📂', padding={left=0, right=1}},
      },
      lualine_c = {
        {'branch', cond=is_not_term},
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
