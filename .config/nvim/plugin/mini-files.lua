local p = require('my.packin')
local u = require('my.utils')

local function setup_maintain_max_height_autocmd()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowUpdate',
    callback = function(args)
      local config = vim.api.nvim_win_get_config(args.data.win_id)

      -- Ensure fixed height
      config.height = vim.o.lines - vim.o.cmdheight - 1

      vim.api.nvim_win_set_config(args.data.win_id, config)
    end,
  })
end

local function setup_fsexplorer_user_cmd()
  vim.api.nvim_create_user_command(
    'FSExplorer',
    function()
      setup_maintain_max_height_autocmd()
      local cfg = {
        windows = {
          preview = false,
          width_focus = vim.o.columns,
        },
      }
      MiniFiles.open(nil, false, cfg)
    end,
    {bang = true, desc = 'Open mini.files in full screen'}
  )
end

p.add{
  src = 'https://github.com/nvim-mini/mini.files',
  enabled = not u.diff_mode(),
  opts = {
    mappings = {
      go_in = '<C-l>',
      go_in_plus = '<CR>',
      go_out = '<C-h>',
      synchronize = '<C-s>',
    },
    options = {
      use_as_default_explorer = true,
    },
    windows = {
      preview = true,
    },
  },
  after_load = function(plugin)
    local show_dotfiles = true
    local filter_show = function()
      return true
    end
    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, '.')
    end

    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      plugin.refresh({ content = { filter = new_filter } })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id, desc = 'Toggle Hidden Files' })
        vim.keymap.set('n', '<C-c>', plugin.close, { buffer = buf_id, desc = 'Close' })
        vim.keymap.set('n', '<C-j>', 'j', { buffer = buf_id, desc = 'Move down' })
        vim.keymap.set('n', '<C-k>', 'k', { buffer = buf_id, desc = 'Move up' })
      end,
    })

    vim.keymap.set('n', '<leader>o',
      function()
        require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
      end,
      {desc = 'Open mini.files (Directory of Current File)'})
    vim.keymap.set('n', '<leader>O',
      function()
        require('mini.files').open(vim.uv.cwd(), true)
      end,
      {desc = 'Open mini.files (cwd)'})

    setup_fsexplorer_user_cmd()
  end
}
