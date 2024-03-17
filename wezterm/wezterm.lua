local wezterm = require('wezterm')

local config = wezterm.config_builder()

-- [[ Common (os-agnostic) config. ]]
local function common_config()
  config.set_environment_variables = {}

  config.enable_scroll_bar = true
  config.font = wezterm.font('JetBrainsMono Nerd Font Mono')
  config.hide_tab_bar_if_only_one_tab = true
  config.keys = {
    { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
  }
  config.window_background_opacity = 0.9
end

local function clink_inject()
  -- Use OSC 7 to set a custom  prompt:
  config.set_environment_variables['prompt'] = '$E]7;file://localhost/$P$E\\$E[35m$P$E[36m$_$G$E[0m '
  -- use a more ls-like output format for dir
  config.set_environment_variables['DIRCMD'] = '/d'
  -- And inject clink into the command prompt
  config.default_prog = { 'cmd.exe', '/s', '/k', 'clink_x64.exe', 'inject', '-q' }
end

local function windows_launchers()
  config.launch_menu = {
    {
      label = 'Bash',
      args = { 'bash.exe', '--login', '-i' },
    },
    {
      label = 'Powershell',
      args = { 'powershell.exe', '-NoLogo' },
    },
  }
end

local function windows_config()
  if wezterm.target_triple ~= 'x86_64-pc-windows-msvc' then
    return
  end

  config.font_size = 13
  clink_inject()
  windows_launchers()
end

local function unix_config()
  if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    return
  end

  config.font_size = 15
end

common_config()
unix_config()
windows_config()

return config
