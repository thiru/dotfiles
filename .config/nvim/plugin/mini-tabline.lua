local p = require('my.packin')

--- Disable tabline if there is only one tabpage and its buffer is a terminal.
local function toggle_tabline()
  if vim.fn.tabpagenr('$') == 1 and vim.bo.buftype == 'terminal' then
    vim.g.minitabline_disable = true
    vim.o.showtabline = 0
  else
    vim.g.minitabline_disable = false
    vim.o.showtabline = 2
  end
end

local function setup_tabline_toggle_autocmd()
  vim.api.nvim_create_autocmd('TabEnter', {
    pattern = '*',
    callback = toggle_tabline
  })
end

p.add{
  src = 'https://github.com/nvim-mini/mini.tabline',
  opts = {
    tabpage_section = 'none',
  },
  after_load = function()
    setup_tabline_toggle_autocmd()
    vim.schedule(toggle_tabline)
  end
}
