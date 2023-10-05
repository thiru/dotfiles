local doc = 'Key mappings for Neovim builtins (i.e. without plugins).'

local keymap = vim.keymap.set

local function leaders()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Disable a single spacebar key-press since we use it as the leader key
  keymap({ 'n', 'v' }, '<Space>', '<Nop>', { desc = '', silent = true })
end

local function config()
  -- Open init.lua
  keymap('n', '<leader>cc', ':e $MYVIMRC<CR>',
         { desc = 'Open main Neovim config (init.lua)', silent = true })
end

local function buffers()
  -- Previous/next buffer
  keymap('n', '<C-j>', ':bp<CR>', { desc = 'Previous buffer', silent = true })
  keymap('n', '<C-k>', ':bn<CR>', { desc = 'Next buffer', silent = true })
end

local function diagnostics()
  keymap('n', '<leader>k', vim.diagnostic.goto_prev)
  keymap('n', '<leader>j', vim.diagnostic.goto_next)
  keymap('n', '<leader>ef', vim.diagnostic.open_float)
  keymap('n', '<leader>ld', function() vim.diagnostic.disable(0) end,
         { desc = 'Disable diagnostics in current buffer' })
end

local function files()
  -- CWD
  keymap('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>',
         { desc = 'Change working directory to that of the current file' })

  -- PWD
  keymap('n', '<leader>wd', ':pwd<CR>', { desc = 'Print current working directory' })

  -- Open file in clipboard
  keymap('n', '<leader>fc', ':e <C-r>+<CR>',
         { desc = 'Open file stored in system clipboard' })

  -- Save file
  keymap('n', '<leader>fs', ':w<CR>', { desc = 'Save current file' })
  keymap('n', '<C-s>', ':w<CR>', { desc = 'Save current file', silent = true })
  keymap('i', '<C-s>', '<C-o>:w<CR>', { desc = 'Save current file', silent = true })
end

local function misc()
  -- Swap colon and semicolon
  keymap({'n', 'v'}, ';', ':')
  keymap({'n', 'v'}, ':', ';')

  -- Command-line up/down
  keymap('c', '<C-j>', '<Down>', { desc = 'Next command (cmd-line mode)' })
  keymap('c', '<C-k>', '<Up>', { desc = 'Previous command (cmd-line mode)' })

  -- Execute current line in shell
  keymap('n','<leader>x', ":exec '!'.getline('.')<CR>", { desc = 'Execute current line in shell' })

  -- Reload config
  keymap('n', '<leader>vs', ':source $MYVIMRC<CR>', { desc = 'Reload (source) vim config' })

  -- Quit
  keymap({ 'n', 'v' }, '<leader>q', ':qall<CR>', { desc = 'Exit Vim (unless unsaved changes)' })
  keymap({ 'n', 'v' }, '<leader>Q', ':qall!<CR>', { desc = 'Exit Vim (ignore unsaved changes)' })
end

local function terminal()
  keymap('t', '<C-space>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
end

local function text_navigation()
  -- Centre screen on find next/previous
  keymap('n', 'n', 'nzzzv', { desc = 'Go to next match and centre screen' })
  keymap('n', 'N', 'Nzzzv', { desc = 'Go to previous match and centre screen' })

  -- Diff mode next/previous change
  if vim.opt.diff:get() then
    keymap('n', '<S-J>', ']czz', { desc = 'Go to next change and centre (diff mode)' })
    keymap('n', '<S-K>', '[czz', { desc = 'Go to previous change and centre (diff mode)' })
  end

  -- Matching bracket
  keymap({'n', 'v'}, '<TAB>', '%', { desc = 'Go to matching bracket, etc.', remap = true })

  -- Navigate by screen lines, not logical lines (i.e. when lines are wrapped)
  keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Search highlight off
  keymap('n', '<leader>ho', ':nohlsearch<CR>', { desc = 'Search highlight off', silent = true })

  -- Toggle word wrap
  keymap('n', '<leader>ww', ':set wrap!<CR>', { desc = 'Toggle word wrap' })
end

local function windows()
  keymap('i', '<C-;>', '<ESC><C-w>', { desc = 'Initiate window prefix key (from insert mode)' })
  keymap({'n', 'v'}, '<C-;>', '<C-w>', { desc = 'Initiate window prefix key (from normal/visual mode)' })
  keymap('t', '<C-;>', '<C-\\><C-n><C-w>', { desc = 'Initiate window prefix key (from terminal mode)' })
end

local function yanking()
  -- Copy everything to the clipboard
  keymap('n', '<leader>ya', ':%y+<CR>', { desc = 'Copy everything to system clipboard' })

  -- Copy current file path to clipboard
  keymap('n', '<leader>yf', ':let @+ = expand("%")<CR>',
         { desc = 'Copy current file path to system clipboard' })

  -- Paste from clipboard
  keymap({'c', 'i'}, '<C-v>', '<C-r>+', { desc = 'Paste from system clipboard (from command/insert mode)' })
  keymap('n', '<C-v>', 'p', { desc = 'Paste from system clipboard (from normal mode)' })
  keymap('t', '<A-v>', '<C-\\><C-n>pi', { desc = 'Paste from system clipboard (from terminal mode)' })
end

local function setup()
  leaders()
  buffers()
  config()
  diagnostics()
  files()
  misc()
  terminal()
  text_navigation()
  windows()
  yanking()
end

return {
  doc = doc,
  setup = setup
}
