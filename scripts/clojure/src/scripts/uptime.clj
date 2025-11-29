#!/usr/bin/env bb

(ns scripts.uptime
  "Display uptime in days"
  (:require
    [clojure.java.shell :as sh]
    [clojure.string :as str]))

(-> (sh/sh "cat" "/proc/uptime")
    :out
    (str/split #"\s+")
    first
    Float/parseFloat ; this is uptime in seconds
    (/ 60 60 24) ; now we have days
    (->> (format "%.1f d"))
    println)
