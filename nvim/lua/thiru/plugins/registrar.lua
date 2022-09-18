local doc = 'Plugin registration.'

function setup(use)
  -- Package manager (seems to be the most popular one written in Lua)
  use 'wbthomason/packer.nvim'

  -- Preferred, light colour scheme
  use 'cormacrelf/vim-colors-github'

  -- Git commands in nvim
  use 'tpope/vim-fugitive'

  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- "gc" to comment visual regions/lines
  use 'numToStr/Comment.nvim'

  -- Highlight, edit, and navigate code
  use 'nvim-treesitter/nvim-treesitter'

  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'

  -- Manage external editor tooling i.e LSP servers
  use 'williamboman/mason.nvim'

  -- Automatically install language servers to stdpath
  use 'williamboman/mason-lspconfig.nvim'

  -- Autocompletion
  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }

  -- Fancier statusline
  use 'nvim-lualine/lualine.nvim'

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable "make" == 1 }
end

return {
  doc = doc,
  register_plugins = register_plugins,
  setup = setup
}
