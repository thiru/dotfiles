local doc = 'Global/builtin settings (not based on any plugins).'

local plain_term = require('thiru.plain-term')

local function set_colour_scheme()
  -- Enable 24-bit colour mode
  vim.opt.termguicolors = true

  if not plain_term.is_enabled() then
    -- Preferred, light colour scheme
    vim.cmd('colorscheme github')
    vim.opt.background = 'light'
  end
end

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
  vim.opt.colorcolumn = '80'

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
  vim.opt.listchars = 'eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣'

  -- Enable mouse in all modes
  vim.opt.mouse = 'a'

  -- Show relative line numbers, except on the current line show absolute
  vim.opt.number = true
  vim.opt.relativenumber = true

  -- Always show the sign column to prevent horizontal jumping
  if plain_term.is_enabled() then
    vim.opt.signcolumn = 'no'
  else
    vim.opt.signcolumn = 'yes'
  end

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
  vim.opt.completeopt = 'menuone,noselect'

  -- Match on longest string first, then full string, etc.
  vim.opt.wildmode = 'list:longest,full'

  highlight_on_yank()

  set_colour_scheme()
end

return {
  doc = doc,
  setup = setup
}
