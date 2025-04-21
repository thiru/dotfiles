#!/usr/bin/env bb

(ns scripts.cpu-freq
  "Show the current average CPU frequency (formatted to a fixed width)."
  (:require
    [clojure.java.io :as io]
    [clojure.math :as math]
    [clojure.string :as str]
    [scripts.utils :as u]))

(defn get-all-freqs []
  (let [grammar-matcher (.getPathMatcher
                          (java.nio.file.FileSystems/getDefault)
                          "glob:scaling_cur_freq")]

    (->> "/sys/devices/system/cpu/cpufreq/"
         io/file
         file-seq
         (filter #(.isFile %))
         (filter #(.matches grammar-matcher (.getFileName (.toPath %))))
         (map #(-> %
                   slurp
                   str/trim
                   Integer/parseInt)))))

(defn avg-freq [freqs]
  (/ (reduce + freqs) (count freqs)))

(defn significant-digits-format
  [freq]
  (let [num-digits (-> freq math/log10 int)]
    (->> (math/pow 10.0 num-digits)
         (/ freq)
         (format "%.1f"))))

(defn run []
  (-> (get-all-freqs)
      avg-freq
      significant-digits-format))

(when (u/bb-cli?)
  (-> (run)
      println))

(comment
  (run))
