#!/usr/bin/env bb

(ns scripts.next-audio-sink
  "Toggle audio devices using pactl."
  (:require [clojure.java.shell :as sh]
            [clojure.string :as str]
            [scripts.utils :as u]))

;; Determine available audio sinks
;; ----------------------------------------------------------------------------

(println "Determining available audio sinks...\n")

(defn get-default-sink
  "Gets the symbolic name of the default sink."
  []
  (->> (sh/sh "pactl" "get-default-sink")
       :out
       str/trim))

(defn get-sinks
  "Gets the output (list of strings) describing details of all sinks."
  []
  (->> (sh/sh "pactl" "list" "sinks")
       :out
       str/split-lines
       (mapv str/trim)))

(comment
  (get-default-sink)
  (get-sinks)
  (parse-sinks (get-sinks) (get-default-sink)))

(defn parse-sinks
  "Parse the result of `get-default-sink` into a useful list of maps."
  [sinks-cmd-out default-sink]
  (loop [idx 0
         sink-infos []]
    (if (not (< idx (count sinks-cmd-out)))
      (do
        (println (format "Found %d audio sink(s):"
                         (count sink-infos)))
        (doseq [sink sink-infos]
          (println (format "* Index %s - %s%s"
                           (:index sink)
                           (:description sink)
                           (if (:active? sink) " - ACTIVE " ""))))
        sink-infos)
      (let [line (nth sinks-cmd-out idx)
            idx-line-match (re-find #"^Sink\s+#(\d+)" line)
            name-line-match (when (not idx-line-match)
                              (re-find #"^Name:\s+(.+)" line))
            desc-line-match (when (not idx-line-match)
                              (re-find #"^Description:\s+(.+)" line))]
        (cond
          idx-line-match
          (recur (inc idx)
                 (conj sink-infos
                       {:idx (count sink-infos)
                        :index (last idx-line-match)}))

          name-line-match
          (recur (inc idx)
                 (update sink-infos
                         (dec (count sink-infos))
                         #(assoc %
                                 :name
                                 (last name-line-match)
                                 :active? (= (last name-line-match)
                                             default-sink))))

          desc-line-match
          (recur (inc idx)
                 (update sink-infos
                         (dec (count sink-infos))
                         #(assoc % :description
                                 (last desc-line-match))))

          :else
          (recur (inc idx)
                 sink-infos))))))

(defn exclude-blacklisted
  "Exclude any blacklisted audio sinks."
  [sinks]
  (let [blacklisted-csv (System/getenv "AUDIO_SINK_BLACKLIST")]
    (if (empty? blacklisted-csv)
      sinks
      (let [blacklisted (->> (str/split blacklisted-csv #",")
                             (map str/lower-case)
                             (map str/trim))]
        (println (format "\nWill ignore %d blacklisted audio sink(s): %s"
                         (count blacklisted)
                         blacklisted-csv))
        (filterv (fn [sink]
                   (not (some #(= % (-> sink :description str/lower-case))
                              blacklisted)))
                 sinks)))))

(def sinks
  (-> (get-sinks)
      (parse-sinks (get-default-sink))
      (exclude-blacklisted)))

(when (empty? sinks)
  (let [msg "No sinks found. Try running `pactl list sinks` yourself."]
    (println msg)
    (u/notify-send "Audio"
                   :body msg
                   :expire-time 2000
                   :icon "audio-volume-medium"
                   :replace-id (u/gen-replace-id)))
  (when (u/bb-cli?)
    (System/exit 1)))

(when (= 1 (count sinks))
  (let [msg (str "Only one output device found: " (:name (first sinks)))]
    (println msg)
    (u/notify-send "Audio"
                   :body msg
                   :expire-time 2000
                   :icon "audio-volume-muted"
                   :replace-id (u/gen-replace-id)))
  (when (u/bb-cli?)
    (System/exit 0)))

;; Determine 'next' audio sink
;; ----------------------------------------------------------------------------

(def next-sink
  (let [active-sink (first (filterv :active? sinks))]
    (nth sinks (inc (:idx active-sink)) (first sinks))))

(def set-sink-cmd-res
  (sh/sh "change_audio_sink.clj" (:index next-sink)))

(when (not (zero? (:exit set-sink-cmd-res)))
  (u/notify-send "Audio"
                 :body "Failed to switch to next audio sink"
                 :expire-time 2000
                 :icon "audio-volume-medium"
                 :replace-id (u/gen-replace-id))
  (when (u/bb-cli?)
    (System/exit (:exit set-sink-cmd-res))))

(u/notify-send "Audio"
               :body (str "Switched to " (:description next-sink))
               :expire-time 2000
               :icon "audio-volume-medium"
               :replace-id (u/gen-replace-id))

nil
