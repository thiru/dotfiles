local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/mfussenegger/nvim-lint',
  name = 'lint',
  cond = not u.diff_mode(),
  after_load = function(plugin)
    plugin.linters_by_ft = {
      javascript = {'quick-lint-js'}, -- install: `yay -S quick-lint-js-git`
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        plugin.try_lint()
      end,
    })
  end
}
