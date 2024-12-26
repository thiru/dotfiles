local u = require('custom.utils')

return {
  'echasnovski/mini.files',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
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
  keys = {
    {
      '<leader>o',
      function()
        require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = 'Open mini.files (Directory of Current File)',
    },
    {
      '<leader>O',
      function()
        require('mini.files').open(vim.uv.cwd(), true)
      end,
      desc = 'Open mini.files (cwd)',
    },
  },
  config = function(_, opts)
    local mini_files = require('mini.files')

    mini_files.setup(opts)

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
      mini_files.refresh({ content = { filter = new_filter } })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id, desc = 'Toggle Hidden Files' })
        vim.keymap.set('n', '<C-c>', mini_files.close, { buffer = buf_id, desc = 'Close' })
        vim.keymap.set('n', '<C-j>', 'j', { buffer = buf_id, desc = 'Move down' })
        vim.keymap.set('n', '<C-k>', 'k', { buffer = buf_id, desc = 'Move up' })
      end,
    })
  end
}
