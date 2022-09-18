local doc = [[
  Global/builtin settings (not based on any plugins).
  See `:help vim.o`.
]]

function setup()
  -- Set highlight on search
  vim.o.hlsearch = false

  -- Make line numbers default
  vim.wo.number = true

  -- Enable mouse mode
  vim.o.mouse = 'a'

  -- Enable break indent
  vim.o.breakindent = true

  -- Save undo history
  vim.o.undofile = true

  -- Case insensitive searching UNLESS /C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Decrease update time
  vim.o.updatetime = 250
  vim.wo.signcolumn = 'yes'

  set_colour_scheme()

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'

  highlight_on_yank()
end

function set_colour_scheme()
  vim.o.termguicolors = true
  vim.cmd('colorscheme github')
  vim.o.background = 'light'
end

-- See `:help vim.highlight.on_yank()`
function highlight_on_yank()
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })
end

return {
  doc = doc,
  highlight_on_yank = highlight_on_yank,
  setup = setup
}
