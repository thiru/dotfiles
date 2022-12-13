local doc = 'Plugin registration.'

local bootstrap = require('thiru.bootstrap')

local function plugins(use)
  -- Package manager (seems to be the most popular one written in Lua)
  use 'wbthomason/packer.nvim'

  -- Alpha (greeter)
  use { 'goolord/alpha-nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

  -- Buffer (tab) bar
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}

  -- Buffer closer (without disrupting windows)
  use 'moll/vim-bbye'

  -- Clojure repl, etc.
  use 'Olical/conjure'

  -- Commenting - "gc" to comment visual regions/lines
  use 'numToStr/Comment.nvim'

  -- Completion engines
  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }
  use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
  use { 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } }

  -- Colour scheme
  use 'projekt0n/github-nvim-theme'
  use 'folke/tokyonight.nvim'
  use 'cormacrelf/vim-colors-github' -- only used for viewing diffs

  -- Colourizer
  use 'norcalli/nvim-colorizer.lua'

  -- File tree explorer
  use { 'nvim-neo-tree/neo-tree.nvim',
        requires = { 'MunifTanjim/nui.nvim',
                     'nvim-lua/plenary.nvim',
                     'nvim-tree/nvim-web-devicons' } }

  -- Git commands in vim
  use 'tpope/vim-fugitive'

  -- Git info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- Git log/diff at cursor
  use 'rhysd/git-messenger.vim'

  -- GUI font resize
  use 'ktunprasert/gui-font-resize.nvim'

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzy-native.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
  use { 'nvim-telescope/telescope-symbols.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
  use { 'cljoly/telescope-repo.nvim', requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' } }

  -- Hop
  use 'phaazon/hop.nvim'

  -- Lisp - parenthesis balancing
  use { 'eraserhd/parinfer-rust', run = 'cargo build --release'}

  -- LSP - collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'

  -- LSP - install language servers to stdpath automatically
  use 'williamboman/mason-lspconfig.nvim'

  -- LSP - manage external editor tooling i.e LSP servers
  use 'williamboman/mason.nvim'

  -- Markdown auto-lists
  use 'gaoDean/autolist.nvim'

  -- Match start/end markers better via %
  use 'andymass/vim-matchup'

  -- Root dir auto-changer
  use 'airblade/vim-rooter'

  -- Status line
  use 'nvim-lualine/lualine.nvim'

  -- Tag bar
  use { 'preservim/tagbar' }

  -- Treesitter (highlight, edit, and navigate code)
  use 'nvim-treesitter/nvim-treesitter'

  -- Treesitter - additional textobjects
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Utils
  use { 'nvim-lua/plenary.nvim' }

  -- Which key
  use 'folke/which-key.nvim'

  -- Window resizer
  use  'simeji/winresizer'

  -- Window separator
  use "nvim-zh/colorful-winsep.nvim"
end

local function setup()
  bootstrap.setup(plugins)
end

return {
  doc = doc,
  setup = setup
}
