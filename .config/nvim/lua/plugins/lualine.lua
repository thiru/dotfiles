local u = require('config.utils')

local function is_not_term()
  return vim.bo.buftype ~= 'terminal'
end

return {
  'nvim-lualine/lualine.nvim',
  cond = not u.is_kitty_scrollback(),
  opts = {
    options = {
      icons_enabled = true,
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {
        {u.get_cwd, cond=is_not_term},
        {u.get_file_parent, cond=is_not_term},
      },
      lualine_c = {{'tabs', max_length=1000, mode=2}},
      lualine_x = {
        {'fileformat', cond=is_not_term},
        {'encoding', cond=is_not_term},
        {'filesize', cond=is_not_term},
      },
      lualine_y = {
        {'diagnostics', cond=is_not_term},
        {'branch', cond=is_not_term},
      },
      lualine_z = {
        {'progress', cond=is_not_term},
        {'location', cond=is_not_term}
      }
    },
  }
}
