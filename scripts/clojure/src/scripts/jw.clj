#!/usr/bin/env bb

(ns scripts.jw
  "Download media from public JWPlayer CDN."
  (:require [babashka.curl :as curl]
            [babashka.process :as bp]
            [cheshire.core :as json]
            [clojure.java.io :as io]
            [clojure.pprint :refer [pprint]]
            [clojure.string :as str]))

;; Vars
;; ----------------------------------------------------------------------------

(def usage "Usage: jw.clj [info|link|download] MEDIA_ID")

(def base-url "https://cdn.jwplayer.com/v2/media/")

;; Functions
;; ----------------------------------------------------------------------------

(defn validate! []
  (when (empty? *command-line-args*)
    (println usage)
    (System/exit 1)))

(defn get-metadata [id]
  (let [get-res (curl/get (str base-url id) {:throw false})]
    (if (>= 307 (:status get-res) 200)
      (json/parse-string (:body get-res) true)
      (do
        (println "Failed to get video metadata. Curl response:\n")
        (pprint get-res)
        (System/exit 2)))))

(defn get-best-video-info [json-res]
  (let [video (->> json-res :playlist first :sources
                   (filter #(= (:type %) "video/mp4"))
                   (sort-by :height)
                   last)]
    (assoc video :title (:title json-res))))

(defn download-video [url output-file-name-sans-ext]
  (let [file-ext (subs url (str/last-index-of url "."))
        output-file-name (str output-file-name-sans-ext file-ext)]
    (println "\nDownloading video...\n")
    (io/copy (:body (curl/get url {:as :bytes}))
             (io/file output-file-name))
    (when (not (.exists (io/file output-file-name)))
      (println "Failed to download video")
      (System/exit 2))
    (str "Finished downloading video to: " output-file-name)))

;; Main
;; ----------------------------------------------------------------------------

(validate!)

(let [cmd (first *command-line-args*)]
  (case cmd
    ("-h" "--help")
    usage

    "info"
    (let [id (second *command-line-args*)
          json-res (get-metadata id)]
      (pprint json-res))

    "link"
    (let [id (second *command-line-args*)
          json-res (get-metadata id)
          video-info (get-best-video-info json-res)]
      (println (format "Highest quality found is %dp:\n"
                       (:height video-info)))
      (pprint video-info)
      (bp/check (bp/process '[xclip -sel clip] {:in (:file video-info)}))
      (println "\nCopied video `file` link to clipboard"))

    "download"
    (let [id (second *command-line-args*)
          json-res (get-metadata id)
          video-info (get-best-video-info json-res)]
      (println (format "Highest quality found is %dp:\n"
                       (:height video-info)))
      (pprint video-info)
      (println (download-video (:file video-info)
                               (:title video-info))))

    (do
      (println "unexpected command:" cmd)
      (System/exit 1))))
