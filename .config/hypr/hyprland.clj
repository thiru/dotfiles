#!/usr/bin/env bb

(ns hyprland
  "Generate hyprland configs."
  (:require [clojure.java.io :as io]
            [scripts.cljcfg.hyprlang :refer [->hyprland-config
                                             bind
                                             env
                                             exec-once
                                             monitor
                                             submap
                                             windowrule
                                             workspace]]
            [scripts.utils :as u]))

;;; Script Vars
;;; ------------

(def hostname (u/hostname))
(def terminal "kitty")
(def neovide-terminal "neovide -- --cmd 'lua vim.g.nvtmux_auto_start = true'")

;;; Machine-Specific Configs
;;; -----------------------------

(def hosts {:default
            {monitor [nil :preferred :auto 1]}
            :tmed
            {monitor [nil :preferred :auto 2]}})

(defn gen-config
  "Generate config for the specified host."
  [host]
  [;;; ------------------------------------------
   ;;; Environment Variables
   ;;; ------------------------------------------
   {env [:XDG_CURRENT_DESKTOP :Hyprland]}
   {env [:XDG_SESSION_TYPE :wayland]}
   {env [:XDG_SESSION_DESKTOP :Hyprland]}

   ;;; ------------------------------------------
   ;;; Monitors
   ;;; ------------------------------------------
   {monitor (-> host monitor)}

   ;;; ------------------------------------------
   ;;; Auto-Start
   ;;; ------------------------------------------

   ;; Notification daemon
   {exec-once :swaync}

   ;; App launcher
   {exec-once "walker --gapplication-service"}

   ;; Authentication agent (e.g. to launch root GUI apps)
   {exec-once "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"}

   ;; Sane OS clipboard behaviour
   {exec-once "wl-paste -t text --watch clipman store --no-persist"}

   ;; Network manager applet (tray icon)
   {exec-once :nm-applet}

   ;; Idle configuration
   {exec-once :hypridle}

   ;; Idle inhibitor (i.e. when playing audio and active window is full-screen)
   {exec-once :idle-mon.clj}

   ;; Blue light filter
   {exec-once :hyprsunset}

   ;; Status bar
   {exec-once "waybar --config ~/.config/waybar/config.hypr.jsonc"}

   ;; Recommended for screen sharing
   {exec-once "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"}

   ;; ydotool daemon
   {exec-once :ydotoold}

   ;; Download latest Bing wallpaper
   {exec-once "bing-wallpaper.clj ~/Pictures/wallpaper/bing.jpg"}

   ;; Restore last chosen wallpaper
   {exec-once "waypaper --restore"}

   ;;; ------------------------------------------
   ;;; Look and Feel
   ;;; ------------------------------------------
   {:general
    {:gaps_in 5
     :gaps_out 10

     :border_size 2

     ;; https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
     :col.active_border "rgba(33ccffee) rgba(00ff99ee) 45deg"
     :col.inactive_border "rgba(595959aa)"

     ;; Set to true enable resizing windows by clicking and dragging on borders and gaps
     :resize_on_border false

     ;; Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
     :allow_tearing false

     :layout :master}}

   {:group
    {:groupbar
     {:enabled true
      :col.active "rgba(6666FFFF)"
      :col.inactive "rgba(595959aa)"
      :font_size 16
      :gradients true
      :gradient_rounding 5
      :height 26
      :indicator_height 0}}}

   {:input
    {:kb_layout :us
     :kb_options "ctrl:nocaps,altwin:swap_alt_win"
     :numlock_by_default true
     :follow_mouse 1
     :sensitivity 0.7 ; -1.0 - 1.0, 0 means no modification.
     :touchpad {:natural_scroll false}}}

   {:misc
    {:font_family "Maple Mono NF"
     :force_default_wallpaper 0 ; Set to 0 or 1 to disable the anime mascot wallpapers
     :disable_hyprland_logo false}} ; If true disables the random hyprland logo / anime girl background. :(

   ;;; ------------------------------------------
   ;;; Key Bindings
   ;;; ------------------------------------------

   ;;; Global Vim Motions
   {bind [:SUPER_CTRL :K :sendshortcut nil :UP :activewindow]}
   {bind [:SUPER_CTRL :J :sendshortcut nil :DOWN :activewindow]}

   ;;; Windows
   ;;; --------
   {bind [:SUPER :Q :killactive]}
   {bind [:SUPER_CTRL :Q :forcekillactive]}
   {bind [:SUPER :X :exec "notify-send -t 1500 -i trashcan_full 'Kill mode activated' && hyprctl kill"]}
   {bind [:SUPER_CTRL :F :togglefloating]}
   {bind [:SUPER_CTRL :F :resizeactive "exact 66% 66%"]}
   {bind [:SUPER_CTRL :F :centerwindow]}
   {bind [:SUPER :F :fullscreen]}
   {bind [:SUPER :TAB :changegroupactive :f]}
   {bind [:SUPER_SHIFT :TAB :changegroupactive :b]}
   {bind [:SUPER :W :swapnext]}
   {bind [:SUPER :N :pin]}
   {bind [:SUPER :S :togglespecialworkspace]}

   ;;; Tab/Group Submap
   ;;; -----------------
   {bind [:SUPER :T :submap :GROUP]}
   {submap [:GROUP]}
   {bind [nil :T :togglegroup]}
   {bind [nil :H :moveintogroup :l]}
   {bind [nil :J :moveintogroup :d]}
   {bind [nil :K :moveintogroup :u]}
   {bind [nil :L :moveintogroup :r]}
   {bind [nil :O :moveoutofgroup]}
   {bind [nil :ESCAPE :submap :reset]}
   {submap [:reset]}

   ;; Move/resize windows with mainMod + LMB/RMB and dragging
   {:bindm [:SUPER "mouse:272" :movewindow]}
   {:bindm [:SUPER "mouse:273" :resizewindow]}

   ;;; Zoom in/out
   {:binde [:SUPER :equal :exec "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"]}
   {:binde [:SUPER :minus :exec "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.9}')"]}
   {:binde [:SUPER :KP_ADD :exec "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"]}
   {:binde [:SUPER :KP_SUBTRACT :exec "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.9}')"]}
   {:binde [:SUPER_CTRL 0 :exec "hyprctl -q keyword cursor:zoom_factor 1]}"]}

   ;;; Apps
   {bind [:SUPER :SPACE :exec "walker --modules applications"]}
   {bind [:SUPER :RETURN :exec neovide-terminal]}
   {bind [:SUPER_CTRL :RETURN :exec terminal]}
   {bind [:SUPER :V :exec :neovide]}
   {bind [:SUPER :O :exec "kitty --start-as fullscreen yazi $HOME"]}
   {bind [:SUPER_CTRL :P :exec "walker --modules power"]}
   {bind [:SUPER_CTRL :C :exec "neovide -- --cmd \"lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('/Key Bindings<CR>', true, true, true), 'n', false)\" $HOME/.config/hypr/hyprland.clj"]}
   {bind [:SUPER :A :exec :next-audio-sink.clj]}
   {bind [:SUPER :SLASH :exec :pass-menu.sh]}
   {bind [:SUPER :P :exec :printscreen-menu.sh]}
   {bind [:SUPER_CTRL :E :exec :screensaver-vid.sh]}
   {bind [:SUPER :PERIOD :exec "walker --modules script-search"]}
   {bind [:SUPER :C :exec "kitty --app-id launcher sh -c 'echo Calculator; qalc'"]}
   {bind [:SUPER_CTRL :W :exec (str neovide-terminal " --cmd \"lua vim.defer_fn(function() vim.api.nvim_chan_send(vim.b.terminal_job_id, 'curl wttr.in/toronto\\r\\n') end, 500)\"")]}

   ;;; Move focus with mainMod + vim keys
   {bind [:SUPER :H :exec "hyprnav l"]}
   {bind [:SUPER :L :exec "hyprnav r"]}
   {bind [:SUPER :K :movefocus :u]}
   {bind [:SUPER :J :movefocus :d]}

   ;;; Switch workspaces with mainMod + [0-9]
   {bind [:SUPER 1 :workspace 1]}
   {bind [:SUPER 2 :workspace 2]}
   {bind [:SUPER 3 :workspace 3]}
   {bind [:SUPER 4 :workspace 4]}
   {bind [:SUPER 5 :workspace 5]}
   {bind [:SUPER 6 :workspace 6]}
   {bind [:SUPER 7 :workspace 7]}
   {bind [:SUPER 8 :workspace 8]}
   {bind [:SUPER 9 :workspace 9]}
   {bind [:SUPER 0 :workspace 10]}
   {bind [:SUPER :GRAVE :workspace :previous]}

   ;;; Switch to next/previous workspace
   {bind [:SUPER_CTRL :L :workspace :e+1]}
   {bind [:SUPER_CTRL :H :workspace :e-1]}

   ;;; Move active window to a workspace with mainMod + SHIFT + [0-9]
   {bind [:SUPER_SHIFT 1 :movetoworkspacesilent 1]}
   {bind [:SUPER_SHIFT 2 :movetoworkspacesilent 2]}
   {bind [:SUPER_SHIFT 3 :movetoworkspacesilent 3]}
   {bind [:SUPER_SHIFT 4 :movetoworkspacesilent 4]}
   {bind [:SUPER_SHIFT 5 :movetoworkspacesilent 5]}
   {bind [:SUPER_SHIFT 6 :movetoworkspacesilent 6]}
   {bind [:SUPER_SHIFT 7 :movetoworkspacesilent 7]}
   {bind [:SUPER_SHIFT 8 :movetoworkspacesilent 8]}
   {bind [:SUPER_SHIFT 9 :movetoworkspacesilent 9]}
   {bind [:SUPER_SHIFT 0 :movetoworkspacesilent 10]}

   ;;; Monitors
   {bind [:SUPER_CTRL :M :movecurrentworkspacetomonitor :+1]}

   ;;; Laptop multimedia keys for volume and LCD brightness
   {:bindel [nil :XF86AudioRaiseVolume :exec "vol.clj up"]}
   {:bindel [nil :XF86AudioLowerVolume :exec "vol.clj down"]}
   {:bindel [nil :XF86AudioMute :exec "vol.clj mute"]}
   {:bindel [nil :XF86AudioMicMute :exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"]}
   {:bindel [nil :XF86MonBrightnessUp :exec "brightness.clj up"]}
   {:bindel [nil :XF86MonBrightnessDown :exec "brightness.clj down"]}

   ;;; Requires playerctl
   {:bindl [nil :XF86AudioNext :exec "playerctl next"]}
   {:bindl [nil :XF86AudioPause :exec "playerctl play-pause"]}
   {:bindl [nil :XF86AudioPlay :exec "playerctl play-pause"]}
   {:bindl [nil :XF86AudioPrev :exec "playerctl previous"]}

   ;;; Vim motions submap
   ;;; -------------------
   {bind [:SUPER :I :submap :VIM]}
   {submap [:VIM]}
   {bind [nil :H :sendshortcut nil :LEFT :activewindow]}
   {bind [nil :J :sendshortcut nil :DOWN :activewindow]}
   {bind [nil :K :sendshortcut nil :UP :activewindow]}
   {bind [nil :L :sendshortcut nil :RIGHT :activewindow]}
   {bind [nil :W :sendshortcut :CTRL :RIGHT :activewindow]}
   {bind [nil :B :sendshortcut :CTRL :LEFT :activewindow]}
   {bind [nil 0 :sendshortcut nil :HOME :activewindow]}
   {bind [:SHIFT 4 :sendshortcut nil :END :activewindow]}
   {bind [:CTRL :D :sendshortcut nil :PAGE_DOWN :activewindow]}
   {bind [:CTRL :U :sendshortcut nil :PAGE_UP :activewindow]}

   {bind [nil :G :submap :VIM_G]}
   {submap [:VIM_G]}
   {bind [nil :G :sendshortcut :CTRL :HOME :activewindow]}
   {bind [nil :G :submap :VIM]}
   {bind [nil :ESCAPE :submap :VIM]}
   {bind [nil :catchall :submap :VIM]}

   {submap [:VIM]}
   {bind [:SHIFT :G :sendshortcut :CTRL :END :activewindow]}
   {bind [nil :I :submap :reset]}
   {bind [:SUPER :I :submap :reset]}
   {bind [nil :ESCAPE :submap :reset]}
   {submap [:reset]}

   ;;; Mouse submap
   ;;; -------------
   {bind [:SUPER :M :submap :MOUSE]}
   {submap [:MOUSE]}
   {bind [nil :SPACE :exec :sim-left-click]}
   {bind [nil :RETURN :exec :sim-right-click]}
   {bind [nil :C :exec :sim-mouse-to-centre]}
   {bind [nil :D :exec :sim-double-click]}
   {bind [nil :F :exec "sim-mouse-to-centre && sim-double-click # e.g. for fullscreening a youtube video"]}
   {bind [nil :F :submap :reset]}; it might be confusing to leave mouse mode on since we can't see the status bar anymore
   ;;; Mouse move (big)
   {:binde [nil :H :exec "ydotool mousemove -- -100 0"]}
   {:binde [nil :L :exec "ydotool mousemove -- 100 0"]}
   {:binde [nil :K :exec "ydotool mousemove -- 0 -100"]}
   {:binde [nil :J :exec "ydotool mousemove -- 0 100"]}
   ;;; Mouse move (small)
   {:binde [:CTRL :H :exec "ydotool mousemove -- -10 0"]}
   {:binde [:CTRL :L :exec "ydotool mousemove -- 10 0"]}
   {:binde [:CTRL :K :exec "ydotool mousemove -- 0 -10"]}
   {:binde [:CTRL :J :exec "ydotool mousemove -- 0 10"]}
   ;;; Exit submap
   {bind [:SUPER :M :submap :reset]}
   {bind [nil :ESCAPE :submap :reset]}
   {submap [:reset]}

   ;;; ------------------------------------------
   ;;; Windows and Workspaces
   ;;; ------------------------------------------

   ;;; Ignore maximize requests from apps. You'll probably like this.
   {windowrule ["suppressevent maximize" "class:.*"]}

   ;;; Fix some dragging issues with XWayland
   {windowrule ["nofocus","class:^$","title:^$","xwayland:1","floating:1","fullscreen:0","pinned:0"]}

   ;;; Show menu's as a small centred floating window
   {windowrule ["float" "class:launcher"]}
   {windowrule ["size 1000 500" "class:launcher"]}

   ;;; Always start browser in a group
   {windowrule ["group set" "title:.*Brave|Chromium|LibreWolf$"]}

   ;;; Make workspace 1 the default and always show it
   {workspace [1 "default:true" "persistent:true"]}])

(defn gen-configs
  "Generate configs for all hosts."
  []
  (doseq [host hosts]
    (let [file-name (format "hyprland.%s.conf" (-> host key name))
          save-to (io/file (-> *file* io/file .getParent)
                           file-name)]
      (->> (gen-config (val host))
           (->hyprland-config)
           (spit save-to))
      (println "Generated config:" file-name))))

(gen-configs)
