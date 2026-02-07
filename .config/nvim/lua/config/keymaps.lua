local doc = 'Define key mappings.'

local function init()
  -- Disable a single spacebar key-press since we use it as the leader key
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Escape insert mode
  vim.keymap.set('i', '<C-;>', '<Esc>', {desc='Escape insert mode', silent=true})

  -- Enter command-line mode
  vim.keymap.set('n', '<leader>;', ':', {desc='Enter command-linemode'})
  vim.keymap.set({'n', 'v'}, 's', ':', {desc='Enter command-linemode'})
  vim.keymap.set({'n', 'v'}, '<leader><leader>', '<CMD>echo ""<CR>', {desc='Clear command line text', silent=true})

  -- Quit
  vim.keymap.set(
    { 'n', 'v' }, '<leader>q',
    function()
      if #vim.api.nvim_list_tabpages() <= 1 then
        vim.cmd.quitall()
      else
        vim.cmd.tabclose()
      end
    end,
    { desc = 'Exit/Close Tab' })
  vim.keymap.set({ 'n', 'v' }, '<leader>Q', '<CMD>qall!<CR>', { desc = 'Exit (ignore unsaved changes/tabs)' })

  -- Buffer (prev) / Diff (next)
  vim.keymap.set(
    {'n', 'v'},
    '<C-j>',
    function()
      if vim.wo.diff then
        vim.cmd('normal! ]czz')
      else
        vim.cmd('bp')
      end
    end,
    { desc = 'Go to next buffer/diff' })

  -- Buffer (next) / Diff (prev)
  vim.keymap.set(
    {'n', 'v'},
    '<C-k>',
    function()
      if vim.wo.diff then
        vim.cmd('normal! [czz')
      else
        vim.cmd('bn')
      end
    end,
    { desc = 'Go to previous buffer/diff' })

  -- Down arrow / Diff (next)
  vim.keymap.set(
    {'n', 'v'},
    '<Down>',
    function()
      if vim.wo.diff then
        vim.cmd('normal! ]czz')
      else
        vim.cmd('normal! j')
      end
    end,
    { desc = 'Go to next buffer/diff' })

  -- Up arrow / Diff (prev)
  vim.keymap.set(
    {'n', 'v'},
    '<Up>',
    function()
      if vim.wo.diff then
        vim.cmd('normal! [czz')
      else
        vim.cmd('normal! k')
      end
    end,
    { desc = 'Go to previous buffer/diff' })

  vim.keymap.set({'n', 'v'}, '<leader>a', '<CMD>b#<CR>', { desc = 'Go to alternate buffer' })

  -- Buffer nav - go to index
  for i=1,9 do
    vim.keymap.set(
      {'i', 'n', 't', 'v'},
      '<A-' .. i .. '>', '<CMD>LualineBuffersJump! ' .. i .. '<CR>',
      {desc = 'Go to buffer ' .. i, silent=true})
  end

  -- Open init.lua
  vim.keymap.set('n', '<leader>ve', ':e $MYVIMRC<CR>:cd %:p:h<CR>:pwd<CR>',
    { desc = 'Open main Neovim config (init.lua)', silent = true })

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
  vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

  -- Use alternate mapping for native <C-g> since I'm using it to change the CWD
  vim.keymap.set('n', '<C-S-g>', '<C-g>', {desc = 'File info'})

  -- Show messages
  vim.keymap.set('n', '<leader>m', '<CMD>messages<CR>', {desc = 'Show messages'})

  -- LSP - inline hints toggle
  vim.keymap.set('n', '<leader>li',
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      vim.notify(vim.lsp.inlay_hint.is_enabled() and 'Inlay hints enabled' or 'Inlay hints disabled')
    end,
    {desc = 'Toggle LSP inlay hints'})

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>k', function() vim.diagnostic.jump({count=-1, float=true}) end)
  vim.keymap.set('n', '<leader>j', function() vim.diagnostic.jump({count=1, float=true}) end)
  vim.keymap.set('n', '<leader>ed', function() vim.diagnostic.enable(false) end,
                 {desc = 'Disable diagnostics in current buffer'})
  vim.keymap.set('n', '<leader>K',
    function() vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines }) end,
    {desc = 'Toggle diagnostic virtual_lines'})

  -- CWD
  vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>',
         { desc = 'Change working directory to that of the current file', silent = true })

  -- PWD
  vim.keymap.set('n', '<leader>wd', function() vim.notify(vim.fn.getcwd()) end, { desc = 'Print current working directory', silent = true })

  -- Open file in clipboard
  vim.keymap.set('n', '<leader>fc', ':e <C-r>+<CR>',
         { desc = 'Open file stored in system clipboard' })

  -- Save file
  vim.keymap.set('n', '<C-s>', '<CMD>w<CR>', { desc = 'Save current file', silent = true })
  vim.keymap.set('i', '<C-s>', '<cmd>write<CR>', { desc = 'Save current file', silent = true })

  -- Command-line up/down
  vim.keymap.set('c', '<C-j>', '<Down>', { desc = 'Next command (cmd-line mode)' })
  vim.keymap.set('c', '<C-k>', '<Up>', { desc = 'Previous command (cmd-line mode)' })

  -- Execute current file
  vim.keymap.set('n', '<leader>!', function() vim.cmd('!./%') end, {desc = 'Execute current script (shell)'})

  vim.keymap.set('t', '<LeftMouse>', '<Nop>', { desc = 'Disable mouse left-click' })
  vim.keymap.set('t', '<2-LeftMouse>', '<Nop>', { desc = 'Disable mouse double left-click' })

  -- Centre screen on find next/previous
  vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Go to next match and centre screen' })
  vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Go to previous match and centre screen' })

  -- Matching bracket
  vim.keymap.set({'n', 'v'}, '<TAB>', '%', { desc = 'Go to matching bracket, etc.', remap = true })

  -- Navigate by screen lines, not logical lines (i.e. when lines are wrapped)
  vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
  vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

  -- Search highlight off
  vim.keymap.set('n', '<leader>ho', '<CMD>nohlsearch<CR>', { desc = 'Search highlight off', silent = true })

  -- Toggle word wrap
  vim.keymap.set('n', '<leader>ww', '<CMD>set wrap!<CR>', { desc = 'Toggle word wrap' })

  -- Copy everything to the clipboard
  vim.keymap.set('n', '<leader>ya', '<CMD>%y+<CR>', { desc = 'Copy everything to system clipboard' })

  -- Copy current file path to clipboard
  vim.keymap.set('n', '<leader>yf', ':let @+ = expand("%")<CR>',
         { desc = 'Copy current file path to system clipboard' })

  -- Paste from clipboard
  vim.keymap.set({'c', 'i'}, '<C-v>', '<C-r>+', { desc = 'Paste from system clipboard (command/insert mode)' })
  vim.keymap.set('n', '<C-v>', 'p', { desc = 'Paste from system clipboard (normal mode)' })

  -- Enter visual block mode (need this in nested vim where ctrl-q doesn't work)
  vim.keymap.set({'n', 't'}, '<C-S-v>', '<C-v>', {desc = 'Enter visual block mode', noremap = true})

  -- Toggle cursor column
  vim.keymap.set('n', '<leader>|', function() vim.o.cursorcolumn = not vim.o.cursorcolumn end, {desc = 'Toggle cursor column'})

  -- Tab - new
  vim.keymap.set({'n', 'v', 't'}, '<C-t>', '<CMD>tabnew<CR>', {desc = 'New tab'})
  vim.keymap.set('n', '<leader>tn', '<CMD>tabnew<CR>', {desc = 'New tab'})

  -- Tab - close
  vim.keymap.set('n', '<leader>td', '<CMD>tabclose<CR>', {desc = 'Close tab'})

  -- Tab - move left/right
  vim.keymap.set('n', '<leader>th', '<CMD>-tabmove<CR>', {desc = 'Move tab left'})
  vim.keymap.set('n', '<leader>tl', '<CMD>+tabmove<CR>', {desc = 'Move tab right'})

  -- Window nav - left/down/up/right
  vim.keymap.set({'i', 't'}, '<A-h>', '<C-\\><C-N><C-w>hi')
  vim.keymap.set({'i', 't'}, '<A-j>', '<C-\\><C-N><C-w>ji')
  vim.keymap.set({'i', 't'}, '<A-k>', '<C-\\><C-N><C-w>ki')
  vim.keymap.set({'i', 't'}, '<A-l>', '<C-\\><C-N><C-w>li')
  vim.keymap.set({'n', 'v'}, '<A-h>', '<C-w>h')
  vim.keymap.set({'n', 'v'}, '<A-j>', '<C-w>j')
  vim.keymap.set({'n', 'v'}, '<A-k>', '<C-w>k')
  vim.keymap.set({'n', 'v'}, '<A-l>', '<C-w>l')

  -- Window resizing
  vim.keymap.set('n', '<C-Left>', '<CMD>vertical resize -1<CR>', {desc = 'Decrease window size vertically', silent=true})
  vim.keymap.set('n', '<C-Right>', '<CMD>vertical resize +1<CR>', {desc = 'Increase window size vertically', silent=true})
  vim.keymap.set('n', '<C-Up>', '<CMD>resize -1<CR>', {desc = 'Decrease window size horizontally', silent=true})
  vim.keymap.set('n', '<C-Down>', '<CMD>resize +1<CR>', {desc = 'Increase window size horizontally', silent=true})
end


return {
  doc = doc,
  init = init,
}
