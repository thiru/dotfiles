#!/usr/bin/env bb

(ns scripts.uptime
  "Display uptime in total hours"
  (:require
    [clojure.java.shell :as sh]
    [clojure.string :as str]))

(-> (sh/sh "cat" "/proc/uptime")
    :out
    (str/split #"\s+")
    first
    Float/parseFloat
    (/ 60 60) ; seconds to hours
    (->> (format "%.1f hrs"))
    println)
