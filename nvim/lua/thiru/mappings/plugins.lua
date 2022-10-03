local doc = 'Key mappings for Neovim builtin actions.'

-- See `:help telescope.builtin`
local function telescope()
  local builtin = require('telescope.builtin')
  local themes = require('telescope.themes')

  vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(themes.get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer]' })

  vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sh', builtin.command_history, { desc = '[S]earch [C]ommand [H]istory' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps (normal mode)' })
  vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = '[S]earch [O]ld files' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>st', builtin.current_buffer_fuzzy_find, { desc = '[S]earch [T]ext in current buffer' })
  vim.keymap.set('n', '<leader>sv', builtin.help_tags, { desc = '[S]earch [V]im help' })
end

local function setup()
  telescope()
end

return {
  doc = doc,
  setup = setup
}
