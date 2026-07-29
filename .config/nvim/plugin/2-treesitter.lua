if require('my.utils').diff_mode() then return end

vim.pack.add({'https://github.com/nvim-treesitter/nvim-treesitter-textobjects'})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end
})

vim.pack.add({'https://github.com/nvim-treesitter/nvim-treesitter'})

local plugin = require('nvim-treesitter')

-- ensure basic parser are installed
local parsers = {
  'bash',
  'c',
  'clojure',
  'commonlisp',
  'css',
  'diff',
  'dockerfile',
  'gitignore',
  'html',
  'java',
  'javascript',
  'json',
  'latex',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'sql',
  'vim',
  'vimdoc',
  'yaml'
}
plugin.install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- check if parser exists and load it
  if not vim.treesitter.language.add(language) then return end
  -- enables syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)
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
