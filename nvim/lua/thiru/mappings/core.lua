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
  -- Close buffer without also closing splits
  vim.keymap.set('n', '<leader>d', ':bprevious|bdelete #<CR>', { desc = 'Close buffer (without closing splits)' })
  vim.keymap.set('n', '<leader>D', ':bprevious|bdelete! #<CR>', { desc = 'Close buffer (without closing splits and ignore modifications)' })

  -- Previous/next buffer
  keymap('n', '<C-j>', ':bp<CR>', { desc = 'Previous buffer', silent = true })
  keymap('n', '<C-k>', ':bn<CR>', { desc = 'Next buffer', silent = true })
end

local function diagnostics()
  keymap('n', '[d', vim.diagnostic.goto_prev)
  keymap('n', ']d', vim.diagnostic.goto_next)
  keymap('n', '<leader>e', vim.diagnostic.open_float)
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
  keymap('n', '<C-s>', ':w<CR>', { desc = 'Save current file' })
  keymap('i', '<C-s>', '<C-o>:w<CR>', { desc = 'Save current file' })
end

local function misc()
  -- Command-line up/down
  keymap('c', '<C-j>', '<Down>', { desc = 'Next command (cmd-line mode)' })
  keymap('c', '<C-k>', '<Up>', { desc = 'Previous command (cmd-line mode)' })

  -- Execute current line in shell
  keymap('n','<leader>x', ":exec '!'.getline('.')<CR>", { desc = 'Execute current line in shell' })

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

  -- End of line
  keymap('n', '<leader>l', '$', { desc = 'Go to end of line' })

  -- Matching bracket
  keymap('n','<TAB>', '%', { desc = 'Go to matching bracket, etc.', remap = true })

  -- Navigate by screen lines, not logical lines (i.e. when lines are wrapped)
  keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Search highlight off
  keymap('n', '<leader>ho', ':nohlsearch<CR>', { desc = 'Search highlight off' })

  -- Toggle word wrap
  keymap('n', '<leader>ww', ':set wrap!<CR>', { desc = 'Toggle word wrap' })
end

local function yanking()
  -- Copy everything to the clipboard
  keymap('n', '<leader>ya', ':%y+<CR>', { desc = 'Copy everything to system clipboard' })

  -- Copy current file path to clipboard
  keymap('n', '<leader>yf', ':let @+ = expand("%")<CR>',
         { desc = 'Copy current file path to system clipboard' })

  -- Paste from clipboard
  keymap('i', '<C-v>', '<C-r>*', { desc = 'Paste from system clipboard' })
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
  yanking()
end

return {
  doc = doc,
  setup = setup
}
