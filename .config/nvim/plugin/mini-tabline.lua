local p = require('my.packin')

--- Make the highlight group for the tab pages section more visible.
local function set_tabpage_hl()
  vim.api.nvim_set_hl(0, 'MiniTablineTabpagesection', { link = 'TabLineSel' })
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
      vim.api.nvim_set_hl(0, 'MiniTablineTabpagesection', { link = 'TabLineSel' })
    end,
  })
end

p.add{
  src = 'https://github.com/nvim-mini/mini.tabline',
  opts = {
    tabpage_section = 'right',
  },
  after_load = set_tabpage_hl
}
