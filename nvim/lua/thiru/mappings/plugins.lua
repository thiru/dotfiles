local doc = 'Key mappings for Neovim builtin actions.'

local function alpha()
  vim.keymap.set('n', '<leader>a', ':Alpha<CR>', { desc = 'Launch Alpha greeter' })
end

local function bbye()
  -- Close buffer without also closing splits
  vim.keymap.set('n', '<leader>d', ':Bwipeout<CR>', { desc = 'Close buffer' })
  vim.keymap.set('n', '<leader>D', ':Bwipeout!<CR>', { desc = 'Close buffer (even if modified)' })
end

local function hop()
  vim.keymap.set('n', '<leader><leader>', ':HopWord<CR>', { desc = 'Hop to any word in buffer' })
end

local function neo_tree()
  vim.keymap.set('n', '<leader>ff', ':Neotree toggle reveal<CR>', { desc = 'File Tree - Toggle visibility' })
end

local function noice()
  vim.keymap.set('n', '<C-n>', ':Noice dismiss<CR>', { desc = 'Dismiss all notifications', silent = true })
end

local function tag_bar()
  vim.keymap.set('n', '<leader>t', ':TagbarToggle<CR>', { desc = '' })
end

local function telescope()
  local builtin = require('telescope.builtin')
  local themes = require('telescope.themes')

  vim.keymap.set('n', '<leader>/',
                 function()
                   builtin.current_buffer_fuzzy_find(themes.get_dropdown({
                     winblend = 10,
                     previewer = false,
                   }))
                 end,
                 { desc = '[/] Fuzzily search in current buffer]' })

  vim.keymap.set('n', '<leader>scc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader>sch', builtin.command_history, { desc = '[S]earch [C]ommand [H]istory' })
  vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = '[S]earch [E]mojis' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [V]im help' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps (normal mode)' })
  vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
  vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = '[S]earch [O]ld files' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
end

local function setup()
  alpha()
  bbye()
  hop()
  neo_tree()
  noice()
  tag_bar()
  telescope()
end

return {
  doc = doc,
  setup = setup
}
