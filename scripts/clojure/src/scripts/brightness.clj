#!/usr/bin/env bb

(ns scripts.brightness
  "Adjust brightness/backlight up/down by 5% using brightnessctl."
  (:require
            [clojure.java.shell :refer [sh]]
            [scripts.utils :as u]))


(def usage "Usage: brightness.clj up|down")

(defn notify-send
  [& {:keys [icon val]
      :or {icon "down" val "???"}}]
  (u/notify-send (format "Brightness (%s)" val)
                 :expire-time 1500
                 :icon icon
                 :hint (str "int:value:" val)
                 :replace-id (u/gen-replace-id)
                 :urgency "low"))

(defn get-current-brightness
  [set-cmd-output]
  (re-find #"\d+%" set-cmd-output))

(defn increase-brightness []
  (let [set-cmd-output (:out (sh "brightnessctl" "set" "+5%"))
        val (get-current-brightness set-cmd-output)]
    (notify-send :icon "up"
                 :val val)))

(defn decrease-brightness []
  (let [set-cmd-output (:out (sh "brightnessctl" "set" "5%-"))
        val (get-current-brightness set-cmd-output)]
    (notify-send :icon "down"
                 :val val)))

(defn -main [& args]
  (case (first args)
    ("-h" "--help")
    (println usage)

    "up"
    (increase-brightness)

    "down"
    (decrease-brightness)

    (nil "")
    (do
      (println usage)
      (System/exit 1))

    (do
      (println "unexpected input:" (first args))
      (System/exit 1))))

(when (u/bb-cli?)
  (apply -main *command-line-args*))
