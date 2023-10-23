local doc = 'Plugin-specific settings.'

local g = require('thiru.globals')

local function apply_quick_edit_mode()
  vim.cmd('normal p')
end

local function alpha()
  if not vim.opt.diff:get() and not g.is_quick_edit_mode() then
    require('alpha').setup(require('alpha.themes.startify').config)
  end
end

local function auto_list()
  require('autolist').setup({})
end

local function bufferline()
  require("bufferline").setup({
    options = {
      always_show_bufferline = false,
      show_buffer_icons = false
    }
  })
end

local function colour_scheme_dark()
  vim.g.edge_style = 'aura'
  vim.g.edge_better_performance = 1
  vim.g.edge_enable_italic = 1
  vim.g.edge_transparent_background = 1
  vim.opt.background = 'dark'
  vim.cmd('colorscheme edge')
end

local function colour_scheme_light()
  vim.g.edge_style = 'aura'
  vim.g.edge_better_performance = 1
  vim.g.edge_enable_italic = 1
  vim.opt.background = 'light'
  vim.cmd('colorscheme edge')
end

-- Prefer light theme unless we're in a TTY/console with a limited colour palette
local function colour_scheme()
  if os.getenv("TERM") == "linux" then
    colour_scheme_dark()
  else
    colour_scheme_light()
  end
end

local function color_scheme_user_cmds()
  vim.api.nvim_create_user_command(
    'ColourSchemeDark',
    colour_scheme_dark,
    {bang = true, desc = 'Set colour scheme to preferred (terminal) dark theme'}
  )

  vim.api.nvim_create_user_command(
    'ColourSchemeLight',
    colour_scheme_light,
    {bang = true, desc = 'Set colour scheme to preferred light theme'}
  )
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
  -- Don't auto-start REPL in diff mode
  if vim.opt.diff:get() then
    vim.g['conjure#client_on_load'] = false
  end

  vim.g['conjure#mapping#doc_word'] = {'<localleader>k'}
  vim.g['conjure#log#botright'] = true

  -- Enable tree-sitter support:
  vim.g['conjure#extract#tree_sitter#enabled'] = true

  -- Don't auto-start Babashka REPL
  vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false

  -- This starts a Fennl REPL with stdio (so no need for Aniseed). The main
  -- issue I had with Aniseed is that requiring local files wasn't working.
  vim.g['conjure#filetype#fennel'] = "conjure.client.fennel.stdio"
end

local function lualine()
  local cwd = function()
    return vim.fn.getcwd()
  end
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'edge',
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diagnostics'},
      lualine_c = {cwd},
      lualine_x = {'filename', 'filesize'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
end

-- See `:help gitsigns.txt`
local function gitsigns()
  if not vim.opt.diff:get() then
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
end

local function gui_font_resize()
  require("gui-font-resize").setup()
end

local function hop()
  require('hop').setup()
end

local function neo_tree()
  require('neo-tree').setup({
    filesystem = {
      follow_current_file = true,
      use_libuv_file_watcher = true
    },
    window = {
      mappings = {
        ['<CR>'] = 'open',
        ['o'] = 'open'
      }
    }
  })
end

local function telescope()
  require('telescope').setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous"
        }
      }
    },
    extensions = {
      repo = {
        list = {
          fd_opts = { '--follow' },
          file_ignore_patterns = { '/%.cache/', '/%.cargo/', '/%.gitlibs/', '/%.local/', '/%.vim/plugged/' },
          pattern = [[^\.(git|stfolder)$]],
        }
      }
    },
    pickers = {
      find_files = {
        find_command = { 'fd', '--follow', '--type', 'f' }
      }
    }
  })

  -- Enable telescope fzy native, if installed
  pcall(require('telescope').load_extension, 'fzy_native')

  -- Enable repo searcher
  require('telescope').load_extension('repo')
end

local function lsp()
  if vim.opt.diff:get() then
    return
  end

  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
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
    'lua_ls',
    'marksman',
    'pyright',
    'quick_lint_js',
    'rust_analyzer',
    'sqlls'
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

  require('lspconfig').lua_ls.setup {
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

local function noice()
  require("noice").setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      long_message_to_split = true, -- long messages will be sent to a split
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  })
end

local function nvim_cmp()
  if vim.opt.diff:get() then
    return
  end

  local cmp = require('cmp')
  local luasnip = require('luasnip')

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
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
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = {
      { name = 'conjure' },
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'buffer' },
    },
  })
end

local function rooter()
  vim.g.rooter_patterns = {'.git', '.stfolder'}
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
      'markdown_inline',
      'python',
      'regex',
      'rust',
      'vim'
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
          ['<localleader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<localleader>A'] = '@parameter.inner',
        },
      },
    },
  }
end

local function which_key()
  require("which-key").setup({})
end

local function win_resizer()
  -- The default key-chord is <C-E> which is too useful for me to have overridden
  vim.g.winresizer_start_key = '<leader>wr'

  -- Amount of columns to resize vertically by
  vim.g.winresizer_vert_resize = 5
end

local function setup()
  if g.is_quick_edit_mode() then
    apply_quick_edit_mode()
  end

  alpha()
  auto_list()
  bufferline()
  colour_scheme()
  color_scheme_user_cmds()
  colourizer()
  comment()
  conjure()
  gitsigns()
  gui_font_resize()
  hop()
  lsp()
  lualine()
  nvim_cmp()
  neo_tree()
  noice()
  rooter()
  telescope()
  treesitter()
  which_key()
  win_resizer()
end

return {
  colour_scheme_light = colour_scheme_light,
  colour_scheme_dark = colour_scheme_dark,
  doc = doc,
  lualine = lualine,
  setup = setup
}
