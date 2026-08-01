local u = require('my.utils')

if u.diff_mode() then return end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('fff.nvim') end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = true, show_scores = true },
}

vim.pack.add({'https://github.com/dmtrKovalenko/fff.nvim'})

local plugin = require('fff')
plugin.setup({
  keymaps = {
    close = { '<C-c>' },
    move_up = { '<Up>', '<C-p>', '<C-k>' },
    move_down = { '<Down>', '<C-n>', '<C-j>' },
  },
  layout = {
    border = 'none',
    prompt_position = 'top',
  },
})

vim.keymap.set('n', '<leader>sf', plugin.find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>sp', plugin.live_grep, { desc = 'Search project' })
vim.keymap.set({'n', 'x'}, '<leader>sw', plugin.live_grep_under_cursor, { desc = 'Search word' })
vim.keymap.set('n', '<leader>sv',
  function()
    plugin.find_files_in_dir(vim.fn.stdpath('config'))
  end,
  { desc = 'Search neovim configs' })

