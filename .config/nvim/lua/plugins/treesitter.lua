return {
  'nvim-treesitter/nvim-treesitter',
  cond = not vim.opt.diff:get(),
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  opts = {
    auto_install = false,
    sync_install = false,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    -- Disabling textobject selection as they will conflict with the superior mini.ai plugin
    textobjects = {
      select = {
        enable = false
      }
    },
    ensure_installed = {
      'bash',
      'c',
      'clojure',
      'commonlisp',
      'csv',
      'css',
      'dockerfile',
      'gitignore',
      'html',
      'java',
      'javascript',
      'json',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'regex',
      'sql',
      'vim',
      'vimdoc'
    },
  },
  config = function(_, opts)
    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
  end
}
