local font_size_default = 15

local function enable_ui2()
  require('vim._core.ui2').enable({
    enable = true,
  })
end

--- Make it easier to see exactly what was yanked.
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

--- Show/hide whitespace chars in certain situations.
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

local function setup()
  -- NOTE: This must happen before plugins are required (otherwise the wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- avoid menu.vim (saves ~100ms)
  vim.g.did_install_default_menus = true

  -- Install: `yay -S maplemononl-nf-cn-unhinted`
  local font_family = vim.env.NEOVIM_FONT_FAMILY or 'Maple Mono NL NF CN'
  local font_size = vim.env.NEOVIM_FONT_SIZE or font_size_default

  -- Set font for GUI front-ends (like Neovide)
  vim.opt.guifont = font_family .. ':h' .. font_size

  -- disable netrw
  vim.g.loaded_netrwPlugin = false

  -- hide end-of-buffer chars, etc.
  vim.o.fillchars = vim.o.fillchars .. 'msgsep:‾,eob: '

  -- exclude some things from shada file
  vim.opt.shada:prepend("r/tmp/,r/private/,rzipfile:,rterm:,rhealth:")

  -- make jumplist remember scroll position and cursor column
  vim.opt.jumpoptions:append("view")

  -- limit syntax highlighting to this many columns
  vim.o.synmaxcol = 200

  -- wrap long lines at word boundaries
  vim.o.linebreak = true

  -- go to last used tab when closing current tab
  vim.o.tabclose='uselast'

  -- ro/ - auto-insert comment leader in various scenarios
  -- 1 - Don't break line after single-letter word
  vim.opt.formatoptions:append("ro/1")

  -- Disable backup and recovery files
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.swapfile = false

  -- Default to creating vertical splits to the right
  vim.o.splitright = true
  -- Default to creating horizontal splits below
  vim.o.splitbelow = true

  -- Highlight current line
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 5

  -- Disable folding by default
  vim.o.foldenable = false
  vim.o.foldlevelstart = 99
  vim.o.foldlevel = 99

  -- Characters to show in place of whitespace characters
  vim.o.listchars = 'tab:-→,trail:█,extends:>,precedes:<'

  -- Highlight search terms and immediately while typing
  vim.o.hlsearch = true
  vim.o.incsearch = true

  -- Wrap to top/bottom when search reaches end/beginning of file
  vim.o.wrapscan = true

  -- Show relative line numbers, except on the current line show absolute
  vim.wo.number = true
  vim.wo.relativenumber = true

  -- Enable mouse in all modes
  vim.o.mouse = 'a'

  -- Hide cmdline by default
  vim.o.cmdheight = 0

  -- Use one global status line (not per window)
  vim.o.laststatus = 3

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
  vim.o.completeopt = 'menuone,noselect,noinsert,fuzzy,popup'

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

  enable_ui2()
  highlight_on_yank()
  maybe_show_listchars()
end

return {
  setup = setup
}
