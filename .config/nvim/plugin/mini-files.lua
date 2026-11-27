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
local function filter_show()
  return true
end
local function filter_hide(fs_entry)
  return not vim.startswith(fs_entry.name, '.')
end

local function toggle_dotfiles()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  plugin.refresh({ content = { filter = new_filter } })
end

local function run_system_command(command, cwd, success_message, failure_message)
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

local function get_selected_entry()
  local entry = plugin.get_fs_entry()
  if not entry then vim.notify('No filesystem entry under cursor') end
  return entry
end

local function open_with_os_default()
  local entry = get_selected_entry()
  if entry then vim.ui.open(entry.path) end
end

local function run_command_in_selected_directory()
  local entry = get_selected_entry()
  if not entry then return end

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
end

local archive_commands = {
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
local archive_extensions = vim.tbl_keys(archive_commands)
table.sort(archive_extensions, function(a, b) return #a > #b end)

local function extract_archive()
  local entry = get_selected_entry()
  if not entry then return end

  local command
  for _, extension in ipairs(archive_extensions) do
    if vim.endswith(entry.name, extension) then
      command = vim.list_extend(vim.deepcopy(archive_commands[extension]), { entry.name })
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
end

local function play_medias()
  local entry = get_selected_entry()
  if entry then
    run_system_command(
      { vim.o.shell, vim.o.shellcmdflag, 'mpv ./**' },
      vim.fs.dirname(entry.path),
      '',
      'mpv error ' .. entry.name
    )
  end
end

local function shred()
  local entry = get_selected_entry()
  if entry then
    run_system_command(
      { vim.o.shell, vim.o.shellcmdflag, 'bleachbit -s "' .. entry.path .. '"' },
      vim.fs.dirname(entry.path),
      'shred complete',
      'shred error ' .. entry.name
    )
  end
end

local function view_images()
  local entry = get_selected_entry()
  if entry then
    run_system_command(
      { vim.o.shell, vim.o.shellcmdflag, 'imv -f -d -x -s full -r .' },
      vim.fs.dirname(entry.path),
      '',
      'imv error ' .. entry.name
    )
  end
end

local function open_current_file_directory()
  plugin.open(vim.api.nvim_buf_get_name(0), true)
end

local function open_working_directory()
  plugin.open(vim.uv.cwd(), true)
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
    vim.keymap.set('n', '<C-space>', open_with_os_default,
      { buffer = buf_id, desc = 'Open with OS default app' })
    vim.keymap.set('n', '!', run_command_in_selected_directory,
      { buffer = buf_id, desc = 'Run command in selected directory' })
    vim.keymap.set('n', 'ge', extract_archive, { buffer = buf_id, desc = 'Extract archive' })
    vim.keymap.set('n', 'gp', view_images, { buffer = buf_id, desc = 'View images' })
    vim.keymap.set('n', 'gS', shred, { buffer = buf_id, desc = 'Shred' })
    vim.keymap.set('n', 'gv', play_medias, { buffer = buf_id, desc = 'Play media files' })

    require('mini.clue').ensure_buf_triggers(buf_id)
  end,
})

vim.keymap.set('n', '<leader>o', open_current_file_directory,
  { desc = 'Open mini.files (Directory of Current File)' })
vim.keymap.set('n', '<leader>O', open_working_directory,
  { desc = 'Open mini.files (cwd)' })

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
