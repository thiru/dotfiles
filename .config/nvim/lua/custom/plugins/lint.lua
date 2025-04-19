local u = require('custom.utils')

return {
  'mfussenegger/nvim-lint',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      javascript = {'quick-lint-js'},
      json = {'jsonlint'},
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        require('lint').try_lint()
      end,
    })
  end
}
