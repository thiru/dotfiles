#!/usr/bin/env bb

(ns scripts.vol
  "Adjust volume using pactl."
  (:require
            [clojure.java.shell :refer [sh]]
            [scripts.utils :as u]))


(def usage "Usage: vol.clj up [percentage]|down [percentage]|(un)mute")

(def default-percentage
  "The default percentage to increase or decrease the volume by"
  5)

(defn notify-send
  [& {:keys [icon vol]
      :or {icon "audio-volume-medium" vol "???"}}]
  (u/notify-send (format "Volume (%s)" vol)
                 :expire-time 1500
                 :icon icon
                 :hint (str "int:value:" vol)
                 :replace-id (u/gen-replace-id)
                 :urgency "low"))

(defn get-current-volume []
  (->> (sh "pactl" "get-sink-volume" "@DEFAULT_SINK@")
       :out
       (re-find #"\d+%")))

(defn muted? []
  (as-> (sh "pactl" "get-sink-mute" "@DEFAULT_SINK@") $
    (:out $)
    (re-find #"yes|no" $)
    (case $
      "yes" true
      "no" false)))

(defn parse-percentage [str]
  (try
    (let [parsed (Integer/parseInt str)]
      (if (neg-int? parsed)
        0
        parsed))
    (catch Exception _ 0)))

(defn increase-volume [percentage]
  (sh "pactl"
      "set-sink-volume"
      "@DEFAULT_SINK@"
      (str "+" percentage "%"))
  (let [curr-vol (get-current-volume)]
    (notify-send :icon "audio-volume-high"
                 :vol curr-vol)))

(defn decrease-volume [percentage]
  (sh "pactl"
      "set-sink-volume"
      "@DEFAULT_SINK@"
      (str "-" percentage "%"))
  (let [curr-vol (get-current-volume)]
    (notify-send :icon "audio-volume-low"
                 :vol curr-vol)))

(defn mute-toggle []
  (sh "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle")
  (let [is-muted (muted?)
        curr-vol (get-current-volume)]
    (if is-muted
      (notify-send :icon "audio-volume-muted"
                   :vol curr-vol)
      (notify-send :icon "audio-volume-medium"
                   :vol curr-vol))
    is-muted))

(defn -main [& args]
  (let [[cmd percent-str] args
        percent-int (if percent-str
                      (parse-percentage percent-str)
                      default-percentage)]
    (if (zero? percent-int)
      (do
        (u/println-stderr "percent must be a positive integer but was:" percent-str)
        (System/exit 1))
      (case cmd
        ("-h" "--help")
        (println usage)

        "up"
        (increase-volume percent-int)

        "down"
        (decrease-volume percent-int)

        ("mute" "unmute")
        (mute-toggle)

        (nil "")
        (do
          (println usage)
          (System/exit 1))

        (do
          (u/println-stderr "unexpected input:" (first args))
          (System/exit 1))))))

(when (u/bb-cli?)
  (apply -main *command-line-args*))
