local doc = 'Plugin-specific settings.'

local plain_term = require('thiru.plain-term')

local function bufferline()
  require("bufferline").setup({})
end

local function colour_scheme()
  local light_blue = '#F2F8FF'

  require("github-theme").setup({
    keyword_style = 'NONE',
    overrides = function()
      return {
        CursorColumn = {bg = light_blue},
        CursorLine = {bg = light_blue}
      }
    end,
    sidebars = {'tagbar'},
    theme_style = "light"
  })
end

local function colourizer()
  require('colorizer').setup({
    'css';
    'javascript';
    html = { mode = 'foreground' }
  })
end

local function comment()
  require('Comment').setup()
end

local function conjure()
  vim.g['conjure#mapping#doc_word'] = {'<localleader>k'}
  vim.g['conjure#log#botright'] = true

  -- Don't auto-start Babashka REPL
  vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false

  -- This starts a Fennl REPL with stdio (so no need for Aniseed). The main
  -- issue I had with Aniseed is that requiring local files wasn't working.
  vim.g['conjure#filetype#fennel'] = "conjure.client.fennel.stdio"
end

-- See `:help lualine.txt`
local function lualine()
  require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = 'onelight',
      component_separators = '|',
      section_separators = '',
    },
  }
end

-- See `:help gitsigns.txt`
local function gitsigns()
  require('gitsigns').setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  }
end

local function hop()
  require('hop').setup()
end

local function nvim_tree()
  require("nvim-tree").setup()
end

-- See `:help telescope` and `:help telescope.setup()`
local function telescope()
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  }

  -- Enable telescope fzy native, if installed
  pcall(require('telescope').load_extension, 'fzy_native')
end

local function treesitter()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'c',
      'clojure',
      'css',
      'dockerfile',
      'fennel',
      'gitignore',
      'html',
      'java',
      'json',
      'lua',
      'make',
      'markdown',
      'python',
      'rust'
    },

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        -- TODO: I'm not sure for this one.
        scope_incremental = '<c-s>',
        node_decremental = '<c-backspace>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end

local function lsp()
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
    print('attach in lsp settings')
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gr', require('telescope.builtin').lsp_references)

    -- See `:help K` for why this keymap
    if not vim.opt.diff:get() then
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    end
    nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      if vim.lsp.buf.format then
        vim.lsp.buf.format()
      elseif vim.lsp.buf.formatting then
        vim.lsp.buf.formatting()
      end
    end, { desc = 'Format current buffer with LSP' })
  end

  -- nvim-cmp supports additional completion capabilities
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = false

  -- Setup mason so it can manage external tooling
  require('mason').setup()

  -- Enable the following language servers
  local servers = {
    'bashls',
    'clangd',
    'clojure_lsp',
    'cmake',
    'cssls',
    'dockerls',
    'html',
    'jdtls',
    'jsonls',
    'marksman',
    'pyright',
    'quick_lint_js',
    'rust_analyzer',
    'sqlls',
    'sumneko_lua'
  }

  -- Ensure the servers above are installed
  require('mason-lspconfig').setup {
    ensure_installed = servers,
  }

  for _, lsp_name in ipairs(servers) do
    require('lspconfig')[lsp_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end

  -- Example custom configuration for lua
  --
  -- Make runtime files discoverable to the server
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  require('lspconfig').sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false, },
      },
    },
  }
end

local function neo_scroll()
  require('neoscroll').setup({
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb'},
  })
end

local function nvim_cmp()
  local cmp = require('cmp')

  cmp.setup({
    snippet = {},
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = {
      { name = 'conjure' },
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
    },
  })
end

local function win_resizer()
  -- The default key-chord is <C-E> which is too useful for me to have overridden
  vim.g.winresizer_start_key = '<leader>wr'

  -- Amount of columns to resize vertically by
  vim.g.winresizer_vert_resize = 5
end

local function setup()
  hop()
  treesitter()

  -- These plugins don't get loaded in plain term mode
  if not plain_term.is_enabled() then
    bufferline()
    colour_scheme()
    colourizer()
    comment()
    conjure()
    gitsigns()
    lsp()
    lualine()
    neo_scroll()
    nvim_cmp()
    nvim_tree()
    telescope()
    win_resizer()
  end
end

return {
  doc = doc,
  setup = setup
}
