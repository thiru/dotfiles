local doc = 'Plugin registration.'

local plain_term = require('thiru.plain-term')

local function setup(use)
  -- Package manager (seems to be the most popular one written in Lua)
  use 'wbthomason/packer.nvim'

  -- Highlight, edit, and navigate code
  use 'nvim-treesitter/nvim-treesitter'

  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Don't load these plugins since they wouldn't be used in plain term mode anyway
  if not plain_term.is_enabled() then
    -- Buffer (tab) bar
    use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}

    -- Commenting - "gc" to comment visual regions/lines
    use 'numToStr/Comment.nvim'

    -- Completion engine
    use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }

    -- Colour scheme
    use 'cormacrelf/vim-colors-github'

    -- Colourizer
    use 'norcalli/nvim-colorizer.lua'

    -- File tree explorer
    use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } }

    -- Git commands in vim
    use 'tpope/vim-fugitive'

    -- Git info in the signs columns and popups
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

    -- Git log/diff at cursor
    use 'rhysd/git-messenger.vim'

    -- Hop
    use 'phaazon/hop.nvim'

    -- LSP - collection of configurations for built-in LSP client
    use 'neovim/nvim-lspconfig'

    -- LSP - install language servers to stdpath automatically
    use 'williamboman/mason-lspconfig.nvim'

    -- LSP - manage external editor tooling i.e LSP servers
    use 'williamboman/mason.nvim'

    -- Match start/end markers better via %
    use 'andymass/vim-matchup'

    -- Status line
    use 'nvim-lualine/lualine.nvim'

    -- Fuzzy Finder (files, lsp, etc)
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable "make" == 1 }

    -- Scroll smoother
    use 'karb94/neoscroll.nvim'

    -- Tag bar
    use { 'preservim/tagbar' }

    -- Whitespace cleaner
    use 'ntpeters/vim-better-whitespace'

    -- Window resizer
    use  'simeji/winresizer'
  end
end

return {
  doc = doc,
  register_plugins = register_plugins,
  setup = setup
}
