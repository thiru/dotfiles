local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.enable_scroll_bar = true
config.font = wezterm.font('JetBrainsMono Nerd Font Mono')
config.font_size = 15
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.9

return config
