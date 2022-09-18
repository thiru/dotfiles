local doc = 'Plugin-specific settings.'

function setup()
  comment()
  lualine()
  gitsigns()
  telescope()
  treesitter()
  lsp()
  nvim_cmp()
end

function comment()
  require('Comment').setup()
end

-- See `:help lualine.txt`
function lualine()
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
function gitsigns()
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

-- See `:help telescope` and `:help telescope.setup()`
function telescope()
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

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')
end

-- See `:help nvim-treesitter`
function treesitter()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'lua', 'python', 'rust' },

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

function lsp()
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
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

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
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Setup mason so it can manage external tooling
  require('mason').setup()

  -- Enable the following language servers
  local servers = { 'clangd', 'rust_analyzer', 'pyright', 'sumneko_lua' }

  -- Ensure the servers above are installed
  require('mason-lspconfig').setup {
    ensure_installed = servers,
  }

  for _, lsp in ipairs(servers) do
    require('lspconfig')[lsp].setup {
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

function nvim_cmp()
  local cmp = require 'cmp'

  cmp.setup {
    mapping = cmp.mapping.preset.insert {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
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
    },
    sources = {
      { name = 'nvim_lsp' },
    },
  }
end

return {
  doc = doc,
  setup = setup
}
