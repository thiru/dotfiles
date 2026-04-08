local p = require('my.packin')
local u = require('my.utils')

-- deps: 'nvim-treesitter/nvim-treesitter-textobjects',

p.add{
  src = 'https://github.com/nvim-treesitter/nvim-treesitter',
  cond = not u.diff_mode(),
  --TODO: build = function() vim.cmd('TSUpdate') end -- but maybe this isn't necessary?
  after_load = function(plugin)
      -- ensure basic parser are installed
      local parsers = {
        'bash',
        'c',
        'clojure',
        'commonlisp',
        'csv',
        'css',
        'diff',
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
        'query',
        'regex',
        'sql',
        'vim',
        'vimdoc'
      }
      plugin.install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then return end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = plugin.get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = plugin.get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
            plugin.install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
  end
}
