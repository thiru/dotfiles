#!/usr/bin/env bb

(ns scripts.adgroups
  "Get AD groups of current user"
  (:require [clojure.java.shell :refer [sh]]
            [clojure.string :as str]
            [scripts.utils :as u]))

(def usage "Usage: adgroups.clj")

(def ps-cmd
  #_["bash" "-c" "cat adgroups.txt"]
  ["powershell.exe" "(New-Object System.DirectoryServices.DirectorySearcher(\"(&(objectCategory=User)(samAccountName=$($env:username)))\")).FindOne().GetDirectoryEntry().memberOf"])

(defn get-groups-via-ps []
  (->> (apply sh ps-cmd)
       :out
       (str/split-lines)
       (map #(-> (str/split % #",")
                 first
                 (subs 3)))
       (sort)
       (str/join "\n")))

(defn -main [& args]
  (case (first args)
    ("-h" "--help")
    (println usage)

    (nil "")
    (println (get-groups-via-ps))

    (do
      (println "unexpected input:" (first args))
      (System/exit 1))))

(when (u/bb-cli?)
  (apply -main *command-line-args*))
