#!/usr/bin/env bb

(ns scripts.change-audio-sink
  "Change audio device using pactl."
  (:require [clojure.java.shell :as sh]
            [scripts.utils :as u]))

;; Help
;; ----------------------------------------------------------------------------

(def usage
  (str "This script sets the default audio 'sink' to that of the specified\n"
       "index, including changing the sink of any active programs.\n\n"
       "You can see available audio sinks by running:\n"
       "$ pactl list sinks\n\n"
       "Usage: change_audio_sink.clj <SINK INDEX>\n"))

;; Validation
;; ----------------------------------------------------------------------------

(when (empty? *command-line-args*)
  (println usage)
  (System/exit 1))

;; Set default sink
;; ----------------------------------------------------------------------------

(def new-sink-idx (first *command-line-args*))

(println "Setting default sink to index" new-sink-idx "\n")

(def set-default-sink-cmd-res
  (u/spy (sh/sh "pactl" "set-default-sink" new-sink-idx)))

(when (not (zero? (:exit set-default-sink-cmd-res)))
  (prn set-default-sink-cmd-res)
  (System/exit 1))

nil
