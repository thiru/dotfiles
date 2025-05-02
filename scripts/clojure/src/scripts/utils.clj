(ns scripts.utils
  "Generic utilities for the Clojure scripts in this folder."
  (:require
            [clojure.java.shell :refer [sh]]
            [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.pprint :as pp]
            [scripts.results :as r]))



(defmacro spy
  "A simpler version of Timbre's spy which simply pretty-prints to stdout
  and returns the eval'd expression."
  [expr]
  `(let [evaled# ~expr]
     (print (str '~expr " => "))
     (pp/pprint evaled#)
     evaled#))

(defn println-stderr
  "Just like `println` except prints to stderr."
  [& args]
  (binding [*out* *err*]
    (apply println args)))

(defn load-if-file
  "Load the file at the given path if it exists."
  [file]
  (let [^java.io.File file-obj (io/as-file file)]
    (if (and file-obj (.exists file-obj))
      (r/r :success "File successfully loaded" {:file file-obj})
      (r/r :error (format "File '%s' was not found or is inaccessible"
                          (or file ""))))))

(defn file-name-sans-ext
  "Get the name of this file excluding the extension."
  [file-name]
  (if-let [ext-idx (str/last-index-of (or file-name "") ".")]
    (subs file-name 0 ext-idx)
    file-name))

(defn bb-cli?
  "Determine whether we're running within Babashka.
  E.g. as opposed to a regular Clojure environment."
  []
  (not (nil? (System/getProperty "babashka.file"))))

(defn is-wayland? []
  (= "wayland" (System/getenv "XDG_SESSION_TYPE")))

(defn is-running? [proc]
  (let [cmd-res (sh "ps" "-C" proc "-o" "command=")]
    (and (zero? (:exit cmd-res))
         (= proc (str/trim (:out cmd-res))))))

(defn get-de
  "Try and determine the currently running desktop environment/window manager.
  This method seems pretty inefficient but there doesn't seem to be another reliable way."
  []
  (cond
    (is-running? "sway") :sway
    (is-running? "Hyprland") :hyprland
    (is-running? "xfce4-session") :xfce
    :else :unknown))

(defn notify-send
  [summary & {:keys [body expire-time hint icon replace-id urgency]}]
  (let [cmd-args (->> ["notify-send"
                       (when expire-time
                        (str "--expire-time=" expire-time))
                       (when hint
                         (str "--hint=" hint))
                       (when icon
                         (str "--icon=" icon))
                       (when replace-id
                         (str "--replace-id=" replace-id))
                       (when urgency
                         (str "--urgency=" urgency))
                       summary
                       (when body
                         body)]
                     (filterv #(not (nil? %))))]
    (apply sh cmd-args)))

(defn gen-replace-id
  "Generate a positive integer to be used as the `replace-id` option of
  notify-send, based on the name of the running Clojure script."
  []
  (-> *file*
      (hash)
      (Math/abs)
      ;; NOTE: seems like the number can't be too large otherwise it's not recognised
      (mod 100)))



(comment
  (load-if-file "deps.edn")
  (file-name-sans-ext "abc/def/thefile.txt"))
