local doc = 'Define key mappings.'


local function init()
  -- Disable a single spacebar key-press since we use it as the leader key
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Quit
  vim.keymap.set({ 'n', 'v' }, '<leader>q', ':qall<CR>', { desc = 'Exit Vim (unless unsaved changes)' })
  vim.keymap.set({ 'n', 'v' }, '<leader>Q', ':qall!<CR>', { desc = 'Exit Vim (ignore unsaved changes)' })

  -- Swap colon and semicolon
  vim.keymap.set({'n', 'v'}, ';', ':')
  vim.keymap.set({'n', 'v'}, ':', ';')

  -- Open init.lua
  vim.keymap.set('n', '<leader>ve', ':e $MYVIMRC<CR>:cd %:p:h<CR>:pwd<CR>',
    { desc = 'Open main Neovim config (init.lua)', silent = true })

  -- Previous/next buffer
  vim.keymap.set('n', '<C-j>', ':bp<CR>', { desc = 'Previous buffer', silent = true })
  vim.keymap.set('n', '<C-k>', ':bn<CR>', { desc = 'Next buffer', silent = true })

  vim.keymap.set('n', '<C-TAB>', ':bn<CR>', { desc = 'Previous buffer', silent = true })
  vim.keymap.set('n', '<C-S-TAB>', ':bp<CR>', { desc = 'Next buffer', silent = true })

  vim.keymap.set('t', '<C-TAB>', '<CMD>bn<CR>', { desc = 'Previous buffer (term)', silent = true })
  vim.keymap.set('t', '<C-S-TAB>', '<CMD>bp<CR>', { desc = 'Next buffer (term)', silent = true })

  -- Direct buffer access
  for i=1,9 do
    vim.keymap.set(
      {'i', 'n', 't', 'v'},
      '<C-' .. i .. '>',
      function()
        local all_buffers = vim.fn.getbufinfo({buflisted = 1})
        if i <= #all_buffers then
          vim.cmd(all_buffers[i].bufnr .. 'buffer')
        end
      end,
      {desc = 'Go to openened buffer by index', silent=true})
  end

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>k', vim.diagnostic.goto_prev)
  vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>ef', vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>ld', function() vim.diagnostic.disable(0) end,
         { desc = 'Disable diagnostics in current buffer' })

  -- CWD
  vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>',
         { desc = 'Change working directory to that of the current file', silent = true })

  -- PWD
  vim.keymap.set('n', '<leader>wd', ':pwd<CR>', { desc = 'Print current working directory', silent = true })

  -- Open file in clipboard
  vim.keymap.set('n', '<leader>fc', ':e <C-r>+<CR>',
         { desc = 'Open file stored in system clipboard' })

  -- Save file
  vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save current file', silent = true })
  vim.keymap.set('i', '<C-s>', '<cmd>write<CR>', { desc = 'Save current file', silent = true })

  -- Command-line up/down
  vim.keymap.set('c', '<C-j>', '<Down>', { desc = 'Next command (cmd-line mode)' })
  vim.keymap.set('c', '<C-k>', '<Up>', { desc = 'Previous command (cmd-line mode)' })

  -- Execute current line in shell
  vim.keymap.set('n','<leader>x', ":exec '!'.getline('.')<CR>", { desc = 'Execute current line in shell' })

  -- Terminal - ESC
  vim.keymap.set('t', '<C-space>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  -- Terminal - in new buffer
  vim.keymap.set('t', '<C-t>', '<CMD>enew<CR><CMD>terminal<CR><CMD>startinsert<CR>', { desc = 'Exit terminal mode' })


  -- Centre screen on find next/previous
  vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Go to next match and centre screen' })
  vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Go to previous match and centre screen' })

  -- Diff mode next/previous change
  if vim.opt.diff:get() then
    vim.keymap.set('n', '<S-J>', ']czz', { desc = 'Go to next change and centre (diff mode)' })
    vim.keymap.set('n', '<S-K>', '[czz', { desc = 'Go to previous change and centre (diff mode)' })
  end

  -- Matching bracket
  vim.keymap.set({'n', 'v'}, '<TAB>', '%', { desc = 'Go to matching bracket, etc.', remap = true })

  -- Navigate by screen lines, not logical lines (i.e. when lines are wrapped)
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Search highlight off
  vim.keymap.set('n', '<leader>ho', ':nohlsearch<CR>', { desc = 'Search highlight off', silent = true })

  -- Toggle word wrap
  vim.keymap.set('n', '<leader>ww', ':set wrap!<CR>', { desc = 'Toggle word wrap' })

  -- Copy everything to the clipboard
  vim.keymap.set('n', '<leader>ya', ':%y+<CR>', { desc = 'Copy everything to system clipboard' })

  -- Copy current file path to clipboard
  vim.keymap.set('n', '<leader>yf', ':let @+ = expand("%")<CR>',
         { desc = 'Copy current file path to system clipboard' })

  -- Paste from clipboard
  vim.keymap.set({'c', 'i'}, '<C-v>', '<C-r>+', { desc = 'Paste from system clipboard (from command/insert mode)' })
  vim.keymap.set('n', '<C-v>', 'p', { desc = 'Paste from system clipboard (from normal mode)' })
  vim.keymap.set('t', '<C-S-v>', '<C-\\><C-n>pi', { desc = 'Paste from system clipboard (from terminal mode)' })

  -- Toggle cursor column
  vim.keymap.set('n', '<leader>|', function() vim.o.cursorcolumn = not vim.o.cursorcolumn end, {desc = 'Toggle cursor column'})
end


return {
  doc = doc,
  init = init,
}
