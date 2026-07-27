if require('my.utils').diff_mode() then return end

vim.pack.add({{
  name = 'conform',
  src = 'https://github.com/stevearc/conform.nvim',
}})

local plugin = require('conform')

plugin.setup({
  -- log_level = vim.log.levels.DEBUG,
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

vim.api.nvim_create_user_command("ConformFormat", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  plugin.format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.keymap.set('n', '<leader>cf', function() plugin.format({async=true}) end, {desc='Format (Conform)'})
vim.keymap.set('v', '<leader>cf', '<CMD>ConformFormat<CR>', {desc='Format (Conform)'})
