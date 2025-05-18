#!/usr/bin/env bb

(ns scripts.unique-files
     "Print unique file extensions in the current directory tree."
     (:require [clojure.java.io :as io]
               [clojure.string :as str]))

(->> (io/file ".")
     file-seq
     (filter #(.isFile %))
     (map #(-> (.getName %)))
     (filter #(not (nil? (str/index-of % "."))))
     (map #(subs % (or (str/last-index-of % ".") 0)))
     distinct
     (str/join " ")
     println)
