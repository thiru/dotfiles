local doc = 'Set global options.'


-- [[ Make it easier to see exactly what was yanked. ]]
local function highlight_on_yank()
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })
end


local function open_help_in_vertical_split()
  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
      if vim.bo.buftype == 'help' then
        vim.cmd('wincmd L')
      end
    end,
    group = vim.api.nvim_create_augroup('HelpVerticalSplit', { clear = true }),
    pattern = '*.txt'
  })
end


-- [[ Show/hide whitespace chars in certain situations. ]]
local function maybe_show_listchars()
  local group = vim.api.nvim_create_augroup('maybe-show-listchars', {clear = true})

  local should_show_listchars = function()
    if not vim.opt.diff:get()
       and vim.bo.buftype ~= 'nofile'
       and vim.bo.buftype ~= 'terminal'
    then
      vim.wo.list = true
    end
  end

  vim.api.nvim_create_autocmd('WinEnter', {
    desc = 'Show whitespace chars for appropriate buffers',
    pattern = '*',
    group = group,
    callback = should_show_listchars
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    desc = 'Hide whitespace (listchars) while editing',
    pattern = '*',
    group = group,
    command = ':set nolist'
  })

  vim.api.nvim_create_autocmd('InsertLeave', {
    desc = 'Show whitespace chars for appropriate buffers',
    pattern = '*',
    group = group,
    callback = should_show_listchars
  })
end


local function init()
  -- Disable backup and recovery files
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.swapfile = false

  -- Show vertical column
  vim.o.colorcolumn = '100'

  -- Highlight current line
  vim.o.cursorline = true

  -- Highlight current column
  vim.o.cursorcolumn = true

  -- Disable folding by default
  vim.o.foldenable = false
  vim.o.foldlevelstart = 99
  vim.o.foldlevel = 99

  -- Characters to show in place of whitespace characters
  vim.o.listchars = 'tab:-→,trail:█,extends:>,precedes:<'

  -- Highlight search terms and immediately while typing
  vim.o.hlsearch = true
  vim.o.incsearch = true

  -- Show relative line numbers, except on the current line show absolute
  vim.wo.number = true
  vim.wo.relativenumber = true

  -- Enable mouse in all modes
  vim.o.mouse = 'a'

  -- Sync clipboard between OS and Neovim.
  vim.o.clipboard = 'unnamedplus'

  -- Preserve indentation even when line is wrapped
  vim.o.breakindent = true

  -- Save undo history
  vim.o.undofile = true -- TODO: consider disabling

  -- Case-insensitive searching UNLESS \C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Ignore case when completing file paths
  vim.o.wildignorecase = true

  -- Always show the sign column (to prevent horizontal jumping)
  vim.wo.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'

  -- NOTE: You should make sure your terminal supports this
  vim.o.termguicolors = true

  -- Use 2 spaces as TAB
  vim.o.expandtab = true
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2

  -- Allow changing the window title
  vim.o.title = true

  -- Disable diagnostics when viewing diffs
  if vim.opt.diff:get() then
    vim.diagnostic.disable()
  end

  highlight_on_yank()
  open_help_in_vertical_split()
  maybe_show_listchars()
end

return {
  doc = doc,
  init = init,
}