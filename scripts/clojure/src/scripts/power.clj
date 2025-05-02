#!/usr/bin/env bb

(ns scripts.power
  "System power options."
  (:require
            [clojure.java.shell :refer [sh]]
            [clojure.string :as str]
            [scripts.utils :as u]))


(def options ["suspend"
              "poweroff"
              "reboot"
              "logout"
              "lock"])

(def usage (format "Usage: power.clj [%s]" (str/join "|" options)))

(defn run-swaylock []
  (u/notify-send "Locking..." :icon "system-lock-screen")
  (sh "swaylock"
      "--daemonize"
      "--ignore-empty-password"
      "--color" "000000"
      "--scaling" "center"
      "--image" (str (System/getenv "HOME") "/software-configs/scripts/linux/locked.png")))

(defn run-i3lock []
  (u/notify-send "Locking..." :icon "system-lock-screen")
  (sh "i3lock"
      "--ignore-empty-password"
      "--tiling"
      (str "--color=" "000000")
      (str "--image=" (System/getenv "HOME") "/software-configs/scripts/linux/locked.png")))

(defn lock []
  (if (u/is-wayland?)
    (run-swaylock)
    (run-i3lock)))

(defn logout []
  (case (u/get-de)
    :hyprland
    (do
      (u/notify-send "Logging out...")
      (sh "hyprctl" "dispatch" "exit"))

    :sway
    (do
      (u/notify-send "Logging out...")
      (sh "swaymsg" "exit"))

    :xfce
    (do
      (u/notify-send "Logging out...")
      (sh "xfce4-session-logout" "--logout"))

    (do
      (u/notify-send "Unknown desktop environment")
      (System/exit 1))))

(defn poweroff []
  (u/notify-send "Shutting down...")
  (sh "systemctl" "poweroff"))

(defn reboot []
  (u/notify-send "Rebooting...")
  (sh "systemctl" "reboot"))

(defn suspend []
  (u/notify-send "Sleeping...")
  (sh "systemctl" "suspend"))

(defn -main [& args]
  (case (first args)
    ("-h" "--help")
    (println usage)

    "lock"
    (lock)

    ("logout")
    (logout)

    "poweroff"
    (poweroff)

    ("reboot")
    (reboot)

    ("suspend")
    (suspend)

    (nil "")
    (do
      (println usage)
      (System/exit 1))

    (do
      (println "unexpected input:" (first args))
      (System/exit 1))))

(when (u/bb-cli?)
  (apply -main *command-line-args*))
