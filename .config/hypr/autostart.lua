--- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on('hyprland.start', function()
  -- Wallpaper
  hl.exec_cmd('wallpaper-update')

  -- Notification daemon
  hl.exec_cmd('fnott')

  -- Bars
  hl.exec_cmd('waybar-reload')

  -- Network manager applet (tray icon)
  hl.exec_cmd('nm-applet')

  -- xwayland support
  hl.exec_cmd('xwayland-satellite')

  -- Idle detection
  hl.exec_cmd('systemctl --user start --now hypridle.service')

  -- Authentication agent
  -- TODO: consider replacing with hyprland's polkit
  hl.exec_cmd('/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1')

  -- Sane OS clipboard behaviour
  hl.exec_cmd('wl-paste -t text --watch clipman store --no-persist')

  -- Redlight filter
  hl.exec_cmd('wlsunset -l 43.6 -L -79.3 -t 5000')
end)
