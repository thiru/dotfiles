#!/usr/bin/env bb

(ns scripts.vol
  "Adjust volume using pactl."
  (:require
            [clojure.java.shell :refer [sh]]
            [scripts.results :as r]
            [scripts.utils :as u])
  (:gen-class)) ; for graalvm

(set! *warn-on-reflection* true) ; for graalvm

(def usage "Usage: vol.clj <up [percentage]|down [percentage]|mute|unmute>")

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

(defn parse-cli-args
  [args]
  {:cmd (first args)
   :percent-int (if (second args)
                  (parse-percentage (second args))
                  default-percentage)})

(defn validate-cli-args
  [cli-args]
  (if (zero? (:percent-int cli-args))
    (r/r :error "Percent must be a positive integer" cli-args)
    cli-args))

(defn run-command
  [cli-args]
  (case (:cmd cli-args)
    ("-h" "--help")
    (do
      (println usage)
      (r/r :success))

    "up"
    (increase-volume (:percent-int cli-args))

    "down"
    (decrease-volume (:percent-int cli-args))

    ("mute" "unmute")
    (mute-toggle)

    (nil "")
    (r/r :error "No sub-command provided. See help.")

    (r/r :error (str "Unexpected sub-command: " (:cmd cli-args)))))

(defn handle-exit
  [result]
  (when (r/failed? result)
    (u/println-stderr (:message result))
    (u/notify-send "Volume Error"
                   :body (:message result)
                   :expire-time 3000
                   :icon "error"
                   :replace-id (u/gen-replace-id)
                   :urgency "low")
    (System/exit 1))
  (System/exit 0))

(defn -main [& args]
  (try
    (handle-exit
      (r/while-success-> (parse-cli-args args)
                         (validate-cli-args)
                         (run-command)))
    (catch Exception ex
      (handle-exit (r/r :fatal (.toString ex))))))

(when (u/bb-cli?)
  (apply -main *command-line-args*))
