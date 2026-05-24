--- See https://wiki.hypr.land/Configuring/Basics/Binds/

local mod = 'SUPER'

local editor = 'neovide'
local fileManager = 'thunar'
local launcher = 'fuzzel'
local terminal = 'kitty'
local nvterm = 'neovide -- +NvtmuxStart'
local curr_zoom = 1.0

local function zoom(diff)
  if diff then
    curr_zoom = math.max(curr_zoom + diff, 1.0)
    hl.config({ cursor = { zoom_factor = curr_zoom } })
  else
    hl.config({ cursor = { zoom_factor = 0 } })
  end
end

local function screenshot()
  local dir = '~/Pictures/screen-shots'
  local grim_cmd = 'grim -g "$(slurp)" ' .. dir .. '/$(date \'+%Y-%m-%dT%H-%M-%S\').png'
  local notify_cmd = 'notify-send "Screenshot saved to ' .. dir .. '"'
  return grim_cmd .. ' && ' .. notify_cmd
end

-- Terminals
hl.bind(mod .. ' + RETURN', hl.dsp.exec_cmd(nvterm))
hl.bind(mod .. ' + CTRL + RETURN', hl.dsp.exec_cmd(terminal))

-- Editor
hl.bind(mod .. ' + V', hl.dsp.exec_cmd(editor))

-- File Manager
hl.bind(mod .. ' + E', hl.dsp.exec_cmd(fileManager))

-- Calculator
hl.bind(mod .. ' + C', hl.dsp.exec_cmd('neovide --wayland_app_id launcher -- +NvtmuxStart --cmd "lua vim.g.nvtmux_auto_start_cmd = \'qalc\'"'))

-- Emoji Picker
hl.bind(mod .. ' + CTRL + E', hl.dsp.exec_cmd('bemoji -c -t'))

-- Waybar Visbility Toggle
hl.bind(mod .. ' + B', hl.dsp.exec_cmd('pkill -SIGUSR1 waybar'))

-- Waybar Reload
hl.bind(mod .. ' + CTRL + B', hl.dsp.exec_cmd('waybar-reload'))

-- Power Menu
hl.bind(mod .. ' + P', hl.dsp.exec_cmd('power.clj menu'))

-- Pass menu
hl.bind(mod .. ' + SLASH', hl.dsp.exec_cmd('pass-menu.sh'))

-- Weather
hl.bind(mod .. ' + W', hl.dsp.exec_cmd('librewolf --new-window https://www.accuweather.com/en/ca/toronto/m5h/daily-weather-forecast/55488'))

-- Screenshot (select region)
hl.bind(mod .. ' + S', hl.dsp.exec_cmd(screenshot()))

hl.bind(mod .. ' + M', hl.dsp.exec_cmd('command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch "hl.dsp.exit()"'))
hl.bind(mod .. ' + F', hl.dsp.window.fullscreen())
hl.bind(mod .. ' + CTRL + F', hl.dsp.window.float({ action = 'toggle' }))
hl.bind(mod .. ' + SPACE', hl.dsp.exec_cmd(launcher))

-- Focus window left/right
hl.bind(mod .. ' + H', hl.dsp.focus({ direction = 'left' }))
hl.bind(mod .. ' + L', hl.dsp.focus({ direction = 'right' }))

-- Swap window with neighbor to the left/right
hl.bind(mod .. ' + CTRL + H', hl.dsp.window.swap({ direction = 'left' }))
hl.bind(mod .. ' + CTRL + L', hl.dsp.window.swap({ direction = 'right' }))

-- Cycle through windows (next/previous) in current workspace
hl.bind(mod .. ' + TAB', hl.dsp.window.cycle_next({ next = true }))
hl.bind(mod .. ' + CTRL + TAB', hl.dsp.window.cycle_next({ next = false }))

-- Focus workspace up/down
hl.bind(mod .. ' + J', hl.dsp.focus({ workspace = 'e+1' }))
hl.bind(mod .. ' + K', hl.dsp.focus({ workspace = 'e-1' }))

-- Move window to next/previous workspace
hl.bind(mod .. ' + CTRL + J', hl.dsp.window.move({ workspace = 'e+1' }))
hl.bind(mod .. ' + CTRL + K', hl.dsp.window.move({ workspace = 'e-1' }))

-- Switch workspaces with mod + [0-9]
-- Move active window to a workspace with mod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mod .. ' + ' .. key,        hl.dsp.focus({ workspace = i}))
  hl.bind(mod .. ' + CTRL + ' .. key, hl.dsp.window.move({ workspace = i }))
end

-- Go to last active (previous) workspace
hl.bind(mod .. ' + GRAVE', hl.dsp.focus({ workspace = 'previous' }))

-- Example special workspace (scratchpad)
hl.bind(mod .. ' + X',         hl.dsp.workspace.toggle_special('magic'))
hl.bind(mod .. ' + CTRL + X', hl.dsp.window.move({ workspace = 'special:magic' }))

-- Scroll through existing workspaces with mod + scroll
hl.bind(mod .. ' + mouse_down', hl.dsp.focus({ workspace = 'e-1' }))
hl.bind(mod .. ' + mouse_up',   hl.dsp.focus({ workspace = 'e+1' }))

-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind(mod .. ' + mouse:272', hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

-- Audio
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd('vol.clj up'),   { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd('vol.clj down'), { locked = true, repeating = true })
hl.bind('XF86AudioMute',        hl.dsp.exec_cmd('vol.clj mute'), { locked = true, repeating = true })
hl.bind('XF86AudioMicMute',     hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'), { locked = true, repeating = true })

-- Brightness
hl.bind('XF86MonBrightnessUp',   hl.dsp.exec_cmd('brightness.clj up'),   { locked = true, repeating = true })
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd('brightness.clj down'), { locked = true, repeating = true })

-- Audio sink toggle (cycle through audio output devices)
hl.bind(mod .. ' + A', hl.dsp.exec_cmd('next-audio-sink.clj'))

-- Requires playerctl
hl.bind('XF86AudioNext',  hl.dsp.exec_cmd('playerctl next'),       { locked = true })
hl.bind('XF86AudioPause', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('XF86AudioPlay',  hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('XF86AudioPrev',  hl.dsp.exec_cmd('playerctl previous'),   { locked = true })

-- Zoom desktop
hl.bind(mod .. ' + EQUAL',     function() zoom(0.1) end,  { repeating = true })
hl.bind(mod .. ' + MINUS',     function() zoom(-0.1) end, { repeating = true })
hl.bind(mod .. ' + BACKSPACE', function() zoom(nil) end,  { locked = true })
