--- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on('hyprland.start', function()
  -- xwayland support
  hl.exec_cmd('xwayland-satellite')

  -- Notification daemon
  hl.exec_cmd('fnott')

  -- Authentication agent
  -- TODO: consider replacing with hyprland's polkit
  hl.exec_cmd('/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1')

  -- Sane OS clipboard behaviour
  hl.exec_cmd('wl-paste -t text --watch clipman store --no-persist')

  -- Bars
  hl.exec_cmd('waybar-reload')

  -- Network manager applet (tray icon)
  hl.exec_cmd('nm-applet')

  -- TODO: Idle configuration
  hl.exec_cmd('hypridle')
  hl.exec_cmd('idle-mon.clj')

  -- Wallpaper
  hl.exec_cmd('wallpaper-update')

  -- Redlight filter (Toronto, Canada)
  hl.exec_cmd('wlsunset -l 43.6 -L -79.3 -t 5000')
end)
