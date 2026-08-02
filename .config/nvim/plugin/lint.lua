local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({{
  name = 'lint',
  src = 'https://github.com/mfussenegger/nvim-lint',
}})

local plugin = require('lint')

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
