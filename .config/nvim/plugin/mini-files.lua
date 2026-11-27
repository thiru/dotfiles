local u = require('mine.utils')

if u.diff_mode() then return end

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

vim.pack.add({'https://github.com/nvim-mini/mini.files'})

local plugin = require('mini.files')

plugin.setup({
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
})

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

local run_system_command = function(command, cwd, success_message, failure_message)
  vim.system(command, { cwd = cwd, text = true }, function(result)
    vim.schedule(function()
      plugin.refresh({ content = { filter = show_dotfiles and filter_show or filter_hide } })

      local output = (result.stdout or '') .. (result.stderr or '')
      local succeeded = result.code == 0
      if output:match('^%s*$') then
        output = succeeded and success_message or failure_message
      end
      vim.notify(output, succeeded and vim.log.levels.INFO or vim.log.levels.ERROR)
    end)
  end)
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id, desc = 'Toggle Hidden Files' })
    vim.keymap.set('n', '<TAB>', plugin.go_in, { buffer = buf_id, desc = 'Go in/open' })
    vim.keymap.set('n', '<C-c>', plugin.close, { buffer = buf_id, desc = 'Close' })
    vim.keymap.set('n', '<ESC>', plugin.close, { buffer = buf_id, desc = 'Close' })
    vim.keymap.set('n', '<C-n>', 'j', { buffer = buf_id, desc = 'Move down' })
    vim.keymap.set('n', '<C-p>', 'k', { buffer = buf_id, desc = 'Move up' })
    vim.keymap.set('n', '<C-space>', function()
      local entry = plugin.get_fs_entry()
      if entry then vim.ui.open(entry.path) end
    end, { buffer = buf_id, desc = 'Open with OS default app' })
    vim.keymap.set('n', '!', function()
      local entry = plugin.get_fs_entry()
      if not entry then
        vim.notify('No filesystem entry under cursor')
        return
      end
      local cwd = entry.fs_type == 'directory' and entry.path or vim.fs.dirname(entry.path)

      vim.ui.input({ prompt = '❯ ', completion = 'shellcmdline' }, function(cmd)
        if not cmd or cmd == '' then return end

        run_system_command(
          { vim.o.shell, vim.o.shellcmdflag, cmd },
          cwd,
          'Command completed',
          'Command failed'
        )
      end)
    end, { buffer = buf_id, desc = 'Run command in selected directory' })
    vim.keymap.set('n', 'ge', function()
      local entry = plugin.get_fs_entry()
      if not entry then
        vim.notify('No filesystem entry under cursor')
        return
      end

      local commands = {
        ['.tar.bz'] = { 'tar', 'xjvf' },
        ['.tar.bz2'] = { 'tar', 'xjvf' },
        ['.tbz'] = { 'tar', 'xjvf' },
        ['.tbz2'] = { 'tar', 'xjvf' },
        ['.tar.gz'] = { 'tar', 'xzvf' },
        ['.tgz'] = { 'tar', 'xzvf' },
        ['.tar.xz'] = { 'tar', 'xJvf' },
        ['.txz'] = { 'tar', 'xJvf' },
        ['.tar.zst'] = { 'tar', '--zstd', '-xvf' },
        ['.tzst'] = { 'tar', '--zstd', '-xvf' },
        ['.tar'] = { 'tar', 'xvf' },
        ['.zip'] = { 'unzip' },
        ['.rar'] = { 'unrar', 'x' },
        ['.7z'] = { '7z', 'x' },
        ['.gz'] = { 'gunzip' },
        ['.bz2'] = { 'bunzip2' },
        ['.xz'] = { 'unxz' },
        ['.zst'] = { 'zstd', '-d' },
      }
      local extensions = vim.tbl_keys(commands)
      table.sort(extensions, function(a, b) return #a > #b end)

      local command
      for _, extension in ipairs(extensions) do
        if vim.endswith(entry.name, extension) then
          command = vim.list_extend(vim.deepcopy(commands[extension]), { entry.name })
          break
        end
      end
      if not command then
        vim.notify('Unsupported archive: ' .. entry.name, vim.log.levels.WARN)
        return
      end

      run_system_command(
        command,
        vim.fs.dirname(entry.path),
        'Extracted ' .. entry.name,
        'Failed to extract ' .. entry.name
      )
    end, { buffer = buf_id, desc = 'Extract selected archive' })

    require('mini.clue').ensure_buf_triggers(buf_id)
  end,
})

vim.keymap.set('n', '<leader>o',
  function()
    plugin.open(vim.api.nvim_buf_get_name(0), true)
  end,
  {desc = 'Open mini.files (Directory of Current File)'})
vim.keymap.set('n', '<leader>O',
  function()
    plugin.open(vim.uv.cwd(), true)
  end,
  {desc = 'Open mini.files (cwd)'})

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
