#!/usr/bin/env bb

(ns scripts.vpn
  "Show/toggle VPN. This is intended to be used with Waybar.

  This requires the following CLI apps:
  - wg-quick"
  (:require
    [clojure.java.shell :refer [sh]]
    [scripts.utils :as u]))


(def usage "Usage: vpn.clj [<state>|<toggle>]")
(def vpn-link-name "wg0")
(def waybar-vpn-module-signal 10)

(defn vpn-link-on? []
  (->> (sh "ip" "link" "show" vpn-link-name)
       :exit
       zero?))

(defn waybar-state []
  (format
    (if (vpn-link-on?)
      "{\"text\": \"\", \"tooltip\": \"VPN '%s' is on\", \"class\": \"on\"}"
      "{\"text\": \"\", \"tooltip\": \"VPN '%s' is off\", \"class\": \"off\"}")
    vpn-link-name))

(defn enable-vpn []
  (sh "wg-quick" "up" vpn-link-name))

(defn disable-vpn []
  (sh "wg-quick" "down" vpn-link-name))

(defn signal-waybar []
  (sh "pkill"
      (str "-RTMIN+" waybar-vpn-module-signal)
      "waybar"))

(defn -main [& args]
  (case (first args)
    ("-h" "--help")
    (println usage)

    ("state")
    (println (waybar-state))

    ("toggle")
    (do
      (if (vpn-link-on?)
        (disable-vpn)
        (enable-vpn))
      (signal-waybar)
      (if (vpn-link-on?)
        (println "ON")
        (println "OFF")))

    (nil "")
    (do
      (println usage)
      (System/exit 1))

    (do
      (println "unexpected argument:" (first args))
      (System/exit 1))))

(when (u/bb-cli?)
  (apply -main *command-line-args*))


(comment
  (vpn-link-on?))
