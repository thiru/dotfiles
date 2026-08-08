local u = require('mine.utils')
local tnvws = require('tabnv.workspace')

--- Get git branch for terminal.
--- This is set externally (currently from a fish trigger)
local function term_branch()
  local tabdir_ok, tabdir = pcall(vim.api.nvim_tabpage_get_var, 0, 'tabbranch')
  if tabdir_ok and tabdir and #tabdir > 0 then
    return ' ' .. tabdir
  end
end

vim.pack.add({'https://github.com/nvim-mini/mini.statusline'})

local plugin = require('mini.statusline')

plugin.setup({
  content = {
    active = function()
      local _, mode_hl  = plugin.section_mode({ trunc_width = 120 })
      local workspaces  = tnvws.statusline_text()
      local cwd         = u.get_cwd()
      local parent_dir  = vim.bo.buftype == 'terminal' and '' or u.get_file_parent()
      local git         = vim.bo.buftype == 'terminal' and term_branch() or plugin.section_git({ trunc_width = 40 })
      local location    = plugin.section_location({ trunc_width = 75 })
      local search      = plugin.section_searchcount({ trunc_width = 75 })

      return plugin.combine_groups({
        { hl = mode_hl, strings = {workspaces} },
        '%<', -- Mark general truncate point
        { hl = 'TermCursor', strings = {cwd} },
        { hl = 'MiniStatuslineFileinfo', strings = {parent_dir} },
        '%=', -- End left alignment
        { hl = 'Search', strings = {search} },
        { hl = 'FloatBorder', strings = {location} },
        { hl = mode_hl, strings = {git} },
      })
    end
  }
})
