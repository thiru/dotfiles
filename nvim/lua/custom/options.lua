local doc = 'Set global options.'


local font_size_default = is_windows() and 12 or 15


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


-- [[ Show/hide whitespace chars in certain situations. ]]
local function maybe_show_listchars()
  local group = vim.api.nvim_create_augroup('maybe-show-listchars', {clear = true})

  local should_show_listchars = function()
    if not vim.opt.diff:get()
       and vim.bo.buftype ~= 'help'
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
  -- NOTE: This must happen before plugins are required (otherwise the wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Disable backup and recovery files
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.swapfile = false

  -- Highlight current line
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- Disable folding by default
  vim.o.foldenable = false
  vim.o.foldlevelstart = 99
  vim.o.foldlevel = 99

  -- Characters to show in place of whitespace characters
  vim.o.listchars = 'tab:-→,trail:█,extends:>,precedes:<'

  -- Highlight search terms and immediately while typing
  vim.o.hlsearch = true
  vim.o.incsearch = true
  vim.o.wrapscan = false

  -- Show relative line numbers, except on the current line show absolute
  vim.wo.number = true
  vim.wo.relativenumber = true

  -- Enable mouse in normal & visual modes only
  vim.o.mouse = 'nv'

  -- Don't show the mode since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  vim.o.clipboard = 'unnamedplus'

  -- Preserve indentation even when line is wrapped
  vim.o.breakindent = true

  -- Don't save undo history to a file
  vim.o.undofile = false

  -- Case-insensitive searching UNLESS \C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Ignore case when completing file paths
  vim.o.wildignorecase = true

  -- Always show the sign column (to prevent horizontal jumping)
  vim.wo.signcolumn = 'yes'

  -- Decrease mapped command timeout
  vim.o.timeoutlen = 300

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'

  -- NOTE: You should make sure your terminal supports this
  vim.o.termguicolors = true

  -- Use 2 spaces as TAB
  vim.o.expandtab = true
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2

  -- NOTE: Needed in order so Markdown files respect tab width
  vim.g.markdown_recommended_style = 0

  -- Allow changing the window title
  vim.o.title = true

  -- Disable diagnostics when viewing diffs
  if vim.opt.diff:get() then
    vim.diagnostic.enable(false)
  end

  highlight_on_yank()
  maybe_show_listchars()
end

return {
  doc = doc,
  font_size_default = font_size_default,
  init = init,
}
