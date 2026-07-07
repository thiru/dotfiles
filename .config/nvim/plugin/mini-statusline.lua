local p = require('my.packin')
local u = require('my.utils')

--- Get git branch for terminal.
--- This is set externally (currently from a fish trigger)
local function term_branch()
  local tabdir_ok, tabdir = pcall(vim.api.nvim_tabpage_get_var, 0, 'tabbranch')
  if tabdir_ok and tabdir and #tabdir > 0 then
    return ' ' .. tabdir
  end
end

p.add{
  src = 'https://github.com/nvim-mini/mini.statusline',
  opts = function(plugin)
    return {
      content = {
        active = function()
          local tab_info    = tostring(vim.api.nvim_tabpage_get_number(0)) .. '/' .. tostring(vim.fn.tabpagenr('$'))
          local _, mode_hl  = plugin.section_mode({ trunc_width = 120 })
          local cwd         = u.get_cwd()
          local parent_dir  = vim.bo.buftype == 'terminal' and '' or u.get_file_parent()
          local git         = vim.bo.buftype == 'terminal' and term_branch() or plugin.section_git({ trunc_width = 40 })
          local diff        = plugin.section_diff({ trunc_width = 75 })
          local diagnostics = plugin.section_diagnostics({ trunc_width = 75 })
          local lsp         = plugin.section_lsp({ trunc_width = 75 })
          local location    = plugin.section_location({ trunc_width = 75 })
          local search      = plugin.section_searchcount({ trunc_width = 75 })

          return plugin.combine_groups({
            { hl = mode_hl,  strings = {tab_info} },
            { hl = 'MiniStatuslineFilename', strings = {cwd} },
            { hl = 'MiniStatuslineFilename', strings = {parent_dir} },
            '%<', -- Mark general truncate point
            { hl = 'FloatBorder',            strings = {diagnostics, lsp, diff} },
            '%=', -- End left alignment
            { hl = mode_hl,                  strings = {git} },
            { hl = 'FloatBorder',            strings = {search, location} },
          })
        end
      }
    }
  end,
}
