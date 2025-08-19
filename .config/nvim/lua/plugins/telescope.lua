local u = require('config.utils')

return {
  'nvim-telescope/telescope.nvim',
  cond = not vim.opt.diff:get(),
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
    local cder_opts
    if u.is_windows() then
      cder_opts = {
        dir_command = {'fd', '--type=d', '--follow', '.', vim.uv.os_homedir()},
        command_executer = {'cmd', '/c', 'dir'},
        previewer_command = '',
        pager_command = 'more',
      }
    else
      cder_opts = {
        dir_command = {'fd', '--type=d', '--follow', '.', vim.uv.os_homedir()},
        pager_command = 'less -RS',
      }
    end

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
        cder = cder_opts,
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

    vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = '[S]earch [E]mojis' })
    vim.keymap.set('n', '<C-g>',      '<CMD>Telescope cder<CR>', { desc = '[S]earch and change to [D]irectory' })
  end
}
