#!/usr/bin/env bb

(ns scripts.hyprnav
  "Navigate to the left or right window within or without a group."
  (:require [clojure.java.shell :refer [sh]]
            [clojure.string :as str]
            [cheshire.core :as json]
            [scripts.results :as r]
            [scripts.utils :as u])
  (:gen-class)) ; for graalvm

(set! *warn-on-reflection* true) ; for graalvm

(def usage "Usage: hypr-win-lr.clj [l|r]")

(defn get-active-window []
  (let [cmd-res (sh "hyprctl" "-j" "activewindow")]
    (if (zero? (:exit cmd-res))
      (json/parse-string (:out cmd-res) true)
      (r/r :error (str "Call to hyprctl failed: " cmd-res)))))

(defn calc-movement-cmd
  [win-info direction]
  (cond
    (nil? win-info)
    (r/r :error "No window info provided")

    (str/blank? (:address win-info))
    (r/r :error "Address if active window not provided")

    (and (not= "l" direction)
         (not= "r" direction))
    (r/r :error (format "Invalid direction: %s. Must be 'l' or 'r'." direction))

    (or (empty? (:grouped win-info))
        (= 1 (count (:grouped win-info))))
    ["hyprctl" "dispatch" "movefocus" direction]

    ;; This means we're in a group with multiple windows
    :else
    (cond
      (and (= "l" direction)
           (= (:address win-info)
              (-> win-info :grouped first)))
      ["hyprctl" "dispatch" "movefocus" direction]

      (and (= "r" direction)
           (= (:address win-info)
              (-> win-info :grouped last)))
      ["hyprctl" "dispatch" "movefocus" direction]

      (= "l" direction)
      ["hyprctl" "dispatch" "changegroupactive" "b"]

      (= "r" direction)
      ["hyprctl" "dispatch" "changegroupactive" "f"]

      :else
      (r/r :error (format "Invalid direction: %s. Must be 'l' or 'r'." direction)))))

(defn run-hypr-cmd
  [args]
  (println (str/join " " args))
  (apply sh args))

(defn do-sub-cmd [args]
  (case (first args)
    ("-h" "--help")
    (do
      (println usage)
      (r/r :success usage))

    (nil "")
    (r/r :error "No direction provided. See help.")

    (r/while-success-> (get-active-window)
                       (calc-movement-cmd (first args))
                       (run-hypr-cmd))))

(defn -main [& args]
  (u/safe-run-exit "Hyprland Groupbar Nav" (do-sub-cmd args)))

(when (u/bb-cli?)
  (apply -main *command-line-args*))
