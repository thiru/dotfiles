local u = require('mine.utils')

if u.diff_mode() then return end

vim.pack.add({{
  name = 'render-markdown',
  src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}})

local plugin = require('render-markdown')

plugin.setup({
  anti_conceal = { enabled = false },
})

vim.keymap.set('n', '<leader>um', '<CMD>RenderMarkdown toggle<CR>', { desc = 'Toggle Markdown rendering' })
