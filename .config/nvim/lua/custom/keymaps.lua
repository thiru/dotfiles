local u = require('custom.utils')
local doc = 'Define key mappings.'

local function go_to_tab(num)
  local tab_handles = vim.api.nvim_list_tabpages()
  if (#tab_handles > 1) and (num <= #tab_handles) then
    vim.api.nvim_set_current_tabpage(tab_handles[num])
  end
end

local function move_tab(dir)
  if dir == 'left' then
    vim.cmd('-tabmove')
  else
    vim.cmd('+tabmove')
  end
end

local function init()
  -- Disable a single spacebar key-press since we use it as the leader key
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Escape insert mode
  vim.keymap.set('i', '<C-d>', '<Esc>', {desc='Escape insert mode', silent=true})

  -- Quit
  vim.keymap.set({ 'n', 'v' }, '<leader>q', '<CMD>qall<CR>', { desc = 'Exit Vim' })
  vim.keymap.set({ 'n', 'v' }, '<leader>Q', '<CMD>qall!<CR>', { desc = 'Exit Vim (ignore unsaved changes)' })

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

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>k', vim.diagnostic.goto_prev)
  vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>ed', function() vim.diagnostic.enable(false) end,
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
  vim.keymap.set('n', '<C-s>', '<CMD>w<CR>', { desc = 'Save current file', silent = true })
  vim.keymap.set('i', '<C-s>', '<cmd>write<CR>', { desc = 'Save current file', silent = true })

  -- Command-line up/down
  vim.keymap.set('c', '<C-j>', '<Down>', { desc = 'Next command (cmd-line mode)' })
  vim.keymap.set('c', '<C-k>', '<Up>', { desc = 'Previous command (cmd-line mode)' })

  -- Execute current file
  vim.keymap.set('n', '<leader>!', function() vim.cmd('!./%') end, {desc = 'Execute current script (shell)'})

  -- Execute/print current line or buffer
  vim.keymap.set('n', '<leader>L', ':.lua<CR>', { desc = 'Execute current line (Lua)' })
  vim.keymap.set('v', '<leader>L', ':lua<CR>', { desc = 'Execute current line (Lua)' })
  vim.keymap.set('n', '<leader><leader>l', '<CMD>source %<CR>', { desc = 'Execute/source current buffer' })
  vim.keymap.set({'n', 'v'}, '<leader>l',
    function()
      local to_execute = u.get_selected_text_or_current_line()
      if #to_execute > 0 then
        local worked, ret = pcall(function() loadstring('vim.print(' .. to_execute .. ')')() end)
        if not worked then
          print(ret)
        end
      end
    end,
    { desc = 'Execute and print selected text or current line (lua)' })

  vim.keymap.set('t', '<LeftMouse>', '<Nop>', { desc = 'Disable mouse left-click' })
  vim.keymap.set('t', '<2-LeftMouse>', '<Nop>', { desc = 'Disable mouse double left-click' })

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

  if not u.nvtmux_auto_started() then -- nvtmux already has these bindings
    -- Tab nav - new
    vim.keymap.set('n', '<C-t>', '<CMD>tabnew<CR>', {desc = 'New tab'})

    -- Tab nav - close
    vim.keymap.set('n', '<leader>td', '<CMD>tabclose<CR>', {desc = 'Close tab'})

    -- Tab nav - next/previous
    vim.keymap.set('n', '<leader>tj', '<CMD>tabNext<CR>', {desc = 'Next tab'})
    vim.keymap.set('n', '<leader>tk', '<CMD>tabPrevious<CR>', {desc = 'Previous tab'})

    -- Tab nav - last accessed
    vim.keymap.set({'n', 'i'}, '<C-`>', '<CMD>:tabnext #<CR>', {desc = 'Go to last accessed tab', silent = true})

    -- Tab nav - previous/next
    vim.keymap.set({'n', 't'}, '<C-S-TAB>', '<CMD>tabprevious<CR>', {desc = 'Next tab', silent = true})
    vim.keymap.set({'n', 't'}, '<C-TAB>', '<CMD>tabnext<CR>', {desc = 'Previous tab', silent = true})
    vim.keymap.set({'n', 't'}, '<C-S-j>', '<CMD>tabprevious<CR>', {desc = 'Next tab', silent = true})
    vim.keymap.set({'n', 't'}, '<C-S-k>', '<CMD>tabnext<CR>', {desc = 'Previous tab', silent = true})

    -- Tab nav - go to index
    for i=1,9 do
      vim.keymap.set(
        {'i', 'n', 't', 'v'},
        '<C-' .. i .. '>',
        function()
          go_to_tab(i)
        end,
        {desc = 'Go to tab by index', silent=true})
    end

    -- Tab nav - move left/right
    vim.keymap.set('n', '<C-,>', function() move_tab('left') end, {desc = 'Move tab to the left'})
    vim.keymap.set('n', '<C-.>', function() move_tab('right') end, {desc = 'Move tab to the right'})
  end

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
