local doc = 'Key mappings for Neovim builtin actions.'

local function hop()
  vim.keymap.set('n', 's', ':HopWord<CR>', { desc = 'Hop to any word in buffer' })
end

local function nvim_tree()
  vim.keymap.set('n', '<leader>ff', ':NvimTreeToggle<CR>', { desc = 'File Tree - Toggle visibility' })
  vim.keymap.set('n', '<leader>fo', ':NvimTreeFindFile<CR>', { desc = 'File Tree - Focus opened file in tree' })
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
  vim.keymap.set('n', '<leader>sr', ':Telescope repo list<CR>', { desc = '[S]earch [R]epos' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
end

local function setup()
  hop()
  nvim_tree()
  tag_bar()
  telescope()
end

return {
  doc = doc,
  setup = setup
}
