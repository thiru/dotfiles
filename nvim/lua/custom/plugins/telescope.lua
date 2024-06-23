-- Fuzzy Finder (files, lsp, etc)

return {
  'nvim-telescope/telescope.nvim',
  cond = not vim.opt.diff:get() and not nvtmux_auto_started(),
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'Zane-/cder.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<C-j>'] = 'move_selection_next',
            ['<C-k>'] = 'move_selection_previous'
          }
        }
      },
      extensions = {
        cder = {
          dir_command = {'fd', '--type=d', '--follow', '.', vim.uv.os_homedir()},
          pager_command = 'less -RS',
        }
      },
      pickers = {
        find_files = {
          find_command = { 'fd', '--follow', '--type', 'f' }
        }
      }
    })

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'cder')

    local builtin = require('telescope.builtin')
    local themes = require('telescope.themes')

    vim.keymap.set('n', '<leader>s/',
                   function()
                     builtin.current_buffer_fuzzy_find(themes.get_dropdown({
                       winblend = 10,
                       previewer = false,
                     }))
                   end,
                   { desc = '[/] Fuzzily search in current buffer]' })

    vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
    vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = '[S]earch [E]mojis' })
    vim.keymap.set('n', '<leader>sd', '<CMD>Telescope cder<CR>', { desc = '[S]earch and change to [D]irectory' })
    vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [V]im help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps (normal mode)' })
    vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
    vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = '[S]earch [O]ld files' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sx', builtin.command_history, { desc = '[S]earch Command History [X]' })
  end
}
