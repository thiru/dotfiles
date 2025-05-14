#!/usr/bin/env bb

(ns scripts.idle-mon
  "Inhibit idle if audio is playing and the active window is full-screen (Wayland-only).

  This requires the following CLI apps:
  - pactl
  - wlrctl"
  (:require
    [clojure.string :as str]
    [clojure.java.shell :refer [sh]]
    [scripts.utils :as u]))


(def usage "Usage: idle-mon.clj")

(def poll-interval-secs 30)


(defn audio-playing?
  "Determine whether audio is playing on any sink."
  []
  (->> (sh "pactl" "list" "sinks")
       :out
       str/split-lines
       (map #(-> (re-find #"\s*State:\s+(\w+)" %)
                 last))
       (some #(= "RUNNING" %))))

(defn full-screen?
  "Determine whether the active window is in full-screen mode."
  []
  (-> (sh "wlrctl" "toplevel" "find" "state:active" "state:fullscreen")
      :exit
      zero?))

(defn start-polling
  "Start polling forever to see if audio is playing on any sink."
  []
  (println "Starting polling for audio playback and active window full-screen")
  (while :forever
    (if (and (audio-playing?) (full-screen?))
      (sh "systemd-inhibit"
          "--what=idle"
          "--who=idle-mon.clj"
          "--why=audio-playing"
          "sleep" (str poll-interval-secs))
      (Thread/sleep (* poll-interval-secs 1000)))))

(defn -main [& args]
  (case (first args)
    ("-h" "--help")
    (println usage)

    (nil "")
    (do
      (start-polling)
      (System/exit 0))

    (do
      (println "unexpected argument:" (first args))
      (System/exit 1))))

(when (u/bb-cli?)
  (apply -main *command-line-args*))


(comment
  (audio-playing?)
  (start-polling))
