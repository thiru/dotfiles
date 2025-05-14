#!/usr/bin/env bb

(ns scripts.bing-wallpaper
  "Download latest Bing wallpaper and use it."
  (:require [babashka.curl :as curl]
            [cheshire.core :as json]
            [clojure.java.io :as io]
            [clojure.string :as str]
            [scripts.results :as r]
            [scripts.utils :as u]))

(def usage "Usage: bing-wallpaper.clj <DOWNLOAD PATH>")

(def region 'en-CA')
(def api-url (format "https://bing.biturl.top/?resolution=UHD&format=json&index=0&mkt=%s" region))
(def default-download-path "bing-wallpaper.jpg")

(defn download-wallpaper
  [url download-path]
  (cond
    (str/blank? url)
    (r/r :error "Source wallpaper URL not provided")

    (str/blank? download-path)
    (r/r :error "Download path not provided")

    :else
    (do
      (println (format "Downloading wallpaper from '%s' to '%s'..." url download-path))
      (io/copy (:body (curl/get url {:as :bytes}))
               (io/file download-path))
      (if (not (.exists (io/file download-path)))
        (r/r :error (str "Failed to download wallpaper to " download-path))
        (r/r :success (str "Successfully downloaded wallpaper to " download-path))))))

(defn call-api []
  (println "Calling Bing wallpaper API...")
  (let [get-res (curl/get api-url {:throw false})]
    (println "Bing wallpaper API call complete")
    (if (or (nil? (:status get-res))
            (<= 300 (:status get-res))
            (>= 199 (:status get-res)))
      (r/r :error "Call to Bing wallpaper API failed" {:details get-res})
      (json/parse-string (:body get-res) true))))

(defn do-sub-cmd
  [args]
  (case (first args)
    ("-h" "--help")
    (r/r :success usage)

    (let [download-path (or (first args) default-download-path)]
      (r/while-success-> (call-api)
                         (get :url)
                         (download-wallpaper download-path)))))

(defn -main [& args]
  (u/safe-run-exit "Bing Wallpaper" (do-sub-cmd args)))

(when (u/bb-cli?)
  (apply -main *command-line-args*))
