local doc = 'Global/builtin settings (not based on any plugins).'

-- Make it easier to see exactly what was yanked
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

local function show_hide_listchars()
  local group = vim.api.nvim_create_augroup('show-listchars', {clear = true})

  local maybe_show_listchars = function()
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
    callback = maybe_show_listchars
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
    callback = maybe_show_listchars
  })
end

local function setup()
  -- Disable backup and recovery files
  vim.opt.backup = false
  vim.opt.writebackup = false
  vim.opt.swapfile = false

  -- Preserve indentation even when line is wrapped
  vim.opt.breakindent = true

  -- Always use system clipboard (for yanking, etc.)
  vim.opt.clipboard = 'unnamedplus'

  -- Show vertical column
  vim.opt.colorcolumn = '100'

  -- Highlight current line
  vim.opt.cursorline = true

  -- Highlight current column
  vim.opt.cursorcolumn = true

  -- Disable folding by default
  vim.opt.foldenable = false
  vim.opt.foldlevelstart = 99
  vim.opt.foldlevel = 99

  -- Highlight search terms and immediately while typing
  vim.opt.hlsearch = true
  vim.opt.incsearch = true

  -- Case-insensitive searching UNLESS /C or capital in search
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Characters to show in place of whitespace characters
  vim.opt.listchars = 'tab:-→,trail:█,extends:>,precedes:<'

  -- Enable mouse in all modes
  vim.opt.mouse = 'a'

  -- Show relative line numbers, except on the current line show absolute
  vim.opt.number = true
  vim.opt.relativenumber = true

  -- Always show the sign column to prevent horizontal jumping
  vim.opt.signcolumn = 'yes'

  -- Reduce timeout for mapped sequence
  -- This is also used by which-key to determine when it pops up
  vim.opt.timeoutlen = 500

  -- Tabbing
  do
    -- Always use spaces as TAB
    vim.opt.expandtab = true

    -- Use 2 spaces as TAB
    vim.opt.shiftwidth = 2

    -- Display a TAB character as two spaces
    vim.opt.tabstop = 2
  end

  -- Save undo history
  vim.opt.undofile = true

  -- Show completion menu even if only one match and don't auto-select
  vim.opt.completeopt = 'menu,menuone,noselect'

  -- Match on longest string first, then full string, etc.
  vim.opt.wildmode = 'list:longest,full'

  -- Ignore case when completing file paths
  vim.opt.wildignorecase = true

  vim.opt.termguicolors = true

  -- Don't want diagnostics when viewing diffs
  if vim.opt.diff:get() then
    vim.diagnostic.disable()
  end

  -- Allow changing the window title
  vim.opt.title = true

  highlight_on_yank()
  open_help_in_vertical_split()
  show_hide_listchars()
end

return {
  doc = doc,
  setup = setup
}
