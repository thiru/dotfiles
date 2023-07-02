local doc = 'Plugin registration.'

local plugins = {
  -- Alpha (greeter)
  { 'goolord/alpha-nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- Buffer (tab) bar
  {'akinsho/bufferline.nvim', tag = "v2.*", dependencies = 'nvim-tree/nvim-web-devicons'},

  -- Buffer closer (without disrupting windows)
  'moll/vim-bbye',

  -- Clojure repl, etc.
  'Olical/conjure',

  -- Commenting - "gc" to comment visual regions/lines
  'numToStr/Comment.nvim',

  -- Completion engines
  { 'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-nvim-lsp' } },
  { 'hrsh7th/cmp-buffer', dependencies = 'nvim-cmp' },
  { 'hrsh7th/cmp-path', dependencies = 'nvim-cmp' },
  { 'L3MON4D3/LuaSnip', dependencies = { 'saadparwaiz1/cmp_luasnip' } },

  -- Colour scheme
  'cormacrelf/vim-colors-github',
  'folke/tokyonight.nvim',

  -- Colourizer
  'norcalli/nvim-colorizer.lua',

  -- File tree explorer
  { 'nvim-neo-tree/neo-tree.nvim',
    dependencies = { 'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons' } },

  -- Git commands in vim
  'tpope/vim-fugitive',

  -- Git info in the signs columns and popups
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Git log/diff at cursor
  'rhysd/git-messenger.vim',

  -- GUI font resize
  'ktunprasert/gui-font-resize.nvim',

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-fzy-native.nvim', dependencies = { 'nvim-telescope/telescope.nvim' } },
  { 'nvim-telescope/telescope-symbols.nvim', dependencies = { 'nvim-telescope/telescope.nvim' } },
  { 'cljoly/telescope-repo.nvim', dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' } },

  -- Flash - easy motions
  {
    'folke/flash.nvim',
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- Lisp - parenthesis balancing
  { 'eraserhd/parinfer-rust', init = function() vim.fn.execute('!cargo build --release') end},

  -- LSP - collection of configurations for built-in LSP client
  'neovim/nvim-lspconfig',

  -- LSP - install language servers to stdpath automatically
  'williamboman/mason-lspconfig.nvim',

  -- LSP - manage external editor tooling i.e LSP servers
  'williamboman/mason.nvim',

  -- Markdown auto-lists
  'gaoDean/autolist.nvim',

  -- Match start/end markers better via %
  'andymass/vim-matchup',

  -- Root dir auto-changer
  'airblade/vim-rooter',

  -- Status line
  'nvim-lualine/lualine.nvim',

  -- Tag bar
  { 'preservim/tagbar' },

  -- Treesitter (highlight, edit, and navigate code)
  'nvim-treesitter/nvim-treesitter',

  -- Treesitter - additional textobjects
  'nvim-treesitter/nvim-treesitter-textobjects',

  -- Utils
  { 'nvim-lua/plenary.nvim' },

  -- Which key
  'folke/which-key.nvim',

  -- Window resizer
  {
    'simeji/winresizer',
    init = function()
      -- The default key-chord is <C-E> which is too useful for me to have overridden
      vim.g.winresizer_start_key = '<leader>wr'

      -- Amount of columns to resize vertically by
      vim.g.winresizer_vert_resize = 5
    end
  }
}

local opts = {}

local function setup()
  require('lazy').setup(plugins, opts)
end

return {
  doc = doc,
  setup = setup
}
