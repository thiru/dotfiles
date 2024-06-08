local doc = 'Define key mappings.'

local plain_term = require('custom.plain-term')


local function init()
  -- Disable a single spacebar key-press since we use it as the leader key
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Quit
  vim.keymap.set({ 'n', 'v' }, '<leader>q', ':qall<CR>', { desc = 'Exit Vim (unless unsaved changes)' })
  vim.keymap.set({ 'n', 'v' }, '<leader>Q', ':qall!<CR>', { desc = 'Exit Vim (ignore unsaved changes)' })

  -- Open command mode for Lua
  vim.keymap.set({ 'n', 'v' }, '<leader>l', ':lua ', { desc = 'Open the command mode for Lua' })

  -- Open init.lua
  vim.keymap.set('n', '<leader>ve', ':e $MYVIMRC<CR>:cd %:p:h<CR>:pwd<CR>',
    { desc = 'Open main Neovim config (init.lua)', silent = true })

  -- Previous/next buffer/tab
  if not plain_term.is_enabled() then -- disable in plain_term mode to avoid confusion
    vim.keymap.set('n', '<C-j>',
      function()
        if #vim.fn.gettabinfo() <= 1 then
          vim.cmd.bprevious()
        else
          vim.cmd.tabprevious()
        end
      end,
      {desc = 'Previous buffer/tab', silent = true})
    vim.keymap.set('n', '<C-k>',
      function()
        if #vim.fn.gettabinfo() <= 1 then
          vim.cmd.bnext()
        else
          vim.cmd.tabnext()
        end
      end,
      {desc = 'Next buffer/tab', silent = true})
  end

  -- Previous/next tab
  vim.keymap.set('n', '<C-S-TAB>', '<CMD>tabprevious<CR>', { desc = 'Next tab', silent = true })
  vim.keymap.set('n', '<C-TAB>', '<CMD>tabnext<CR>', { desc = 'Previous tab', silent = true })
  vim.keymap.set('t', '<C-S-TAB>', '<CMD>tabprevious<CR>', { desc = 'Next tab (term)', silent = true })
  vim.keymap.set('t', '<C-TAB>', '<CMD>tabnext<CR>', { desc = 'Previous tab (term)', silent = true })

  -- New tab (empty buffer)
  vim.keymap.set('n', '<C-t>', '<CMD>tabnew<CR>', { desc = 'Open new tab' })
  -- New tab (new terminal also)
  vim.keymap.set('t', '<C-t>', '<CMD>tabnew<CR><CMD>terminal<CR><CMD>startinsert<CR>', { desc = 'Open terminal in new tab' })

  -- Direct buffer/tab access
  local function goto_buffer(bufnr)
    local all_buffers = vim.fn.getbufinfo({buflisted = 1})
    if bufnr <= #all_buffers then
      vim.cmd(all_buffers[bufnr].bufnr .. 'buffer')
    end
  end

  local function goto_tabnr(tabnr, all_tabs)
    if tabnr <= #all_tabs then
      if vim.fn.mode() == 't' then
        local keys = vim.api.nvim_replace_termcodes('<C-\\><C-n>' .. all_tabs[tabnr].tabnr .. 'gt<CR>i', true, true, true)
        vim.api.nvim_feedkeys(keys, 'n', false)
      else
        vim.cmd('normal ' .. all_tabs[tabnr].tabnr .. 'gt')
      end
    end
  end

  for i=1,9 do
    vim.keymap.set(
      {'i', 'n', 't', 'v'},
      '<C-' .. i .. '>',
      function()
        local all_tabs = vim.fn.gettabinfo()
        if #all_tabs <= 1 then
          goto_buffer(i)
        else
          goto_tabnr(i, all_tabs)
        end
      end,
      {desc = 'Go to openened buffer/tab by index', silent=true})
  end

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
  vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>k', vim.diagnostic.goto_prev)
  vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>ed', function() vim.diagnostic.disable(0) end,
                 {desc = 'Disable diagnostics in current buffer'})

  -- CWD
  vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>',
         { desc = 'Change working directory to that of the current file', silent = true })

  -- PWD
  vim.keymap.set('n', '<leader>wd', function() vim.notify(vim.fn.getcwd()) end, { desc = 'Print current working directory', silent = true })

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
  vim.keymap.set('n','<leader>x', ':exec "!".getline(".")<CR>', { desc = 'Execute current line in shell' })

  -- Terminal - ESC
  vim.keymap.set('t', '<C-space>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  vim.keymap.set('t', '<LeftMouse>', '<Nop>', { desc = 'Disable mouse left-click' })
  vim.keymap.set('t', '<2-LeftMouse>', '<Nop>', { desc = 'Disable mouse double left-click' })

  -- Terminal - new
  vim.keymap.set('n', '<leader>t', ':term<CR>i',{ desc = 'Launch terminal' })

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
  vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
  vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

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

  -- Window navigation
  vim.keymap.set({'i', 't'}, '<A-h>', '<C-\\><C-N><C-w>hi')
  vim.keymap.set({'i', 't'}, '<A-j>', '<C-\\><C-N><C-w>ji')
  vim.keymap.set({'i', 't'}, '<A-k>', '<C-\\><C-N><C-w>ki')
  vim.keymap.set({'i', 't'}, '<A-l>', '<C-\\><C-N><C-w>li')
  vim.keymap.set({'n', 'v'}, '<A-h>', '<C-w>h')
  vim.keymap.set({'n', 'v'}, '<A-j>', '<C-w>j')
  vim.keymap.set({'n', 'v'}, '<A-k>', '<C-w>k')
  vim.keymap.set({'n', 'v'}, '<A-l>', '<C-w>l')

  -- Window resizing
  vim.keymap.set('n', '<C-Left>', ':vertical resize -1<CR>', {desc = 'Decrease window size vertically', silent=true})
  vim.keymap.set('n', '<C-Right>', ':vertical resize +1<CR>', {desc = 'Increase window size vertically', silent=true})
  vim.keymap.set('n', '<C-Up>', ':resize -1<CR>', {desc = 'Decrease window size horizontally', silent=true})
  vim.keymap.set('n', '<C-Down>', ':resize +1<CR>', {desc = 'Increase window size horizontally', silent=true})
end


return {
  doc = doc,
  init = init,
}
