(ns scripts.utils
  "Generic utilities for the Clojure scripts in this folder."
  (:require [babashka.process :as bp]
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

(defmacro show-help
  "Display help based on the current script's namespace and anything `extra`."
  [extra]
  `(let [extra-help# (str (-> *ns* meta :doc)
                       (if (str/blank? ~extra)
                         ""
                         (str "\n\n" ~extra)))]
     (println extra-help#)
     (if (str/blank? extra-help#)
       (r/r :error "No help provided")
       (r/r :success "Help printed"))))

(defn surround
  "Surround `text` with `pre` and `post`."
  [pre post text]
  (str pre text post))

(defn indent-line
  "Ident the `line` by `indent` spaces."
  [line indent]
  (str (str/join "" (repeat indent " "))
       line))

(defn println-stderr
  "Just like `println` except prints to stderr."
  [& args]
  (binding [*out* *err*]
    (apply println args)))

(defn hostname
  "Get the hostname of this machine."
  []
  (->> "hostname"
       (bp/shell {:out :string})
       :out
       str/trim))

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
      (abs)
      ;; NOTE: seems like the number can't be too large otherwise it's not recognised
      (mod 100)))

(defn notify-send-error
  [title result]
  (notify-send title
               :body (str (:message result)
                          (when (:details result)
                            (str "\n\n"
                                 (with-out-str
                                   (pp/pprint (:details result))))))
               :expire-time 5000
               :icon "error"
               :replace-id (gen-replace-id)
               :urgency "low"))

(defmacro safe-run-exit
  "Safely run the given expression, ensuring any errors or exceptions are caught and displayed."
  [notify-title expr]
  `(try
     (let [result# ~expr]
       (when (r/failed? result#)
         (println-stderr result#)
         (notify-send-error ~notify-title result#)
         (System/exit 1)))
     (catch Exception ex
       (println-stderr ex)
       (notify-send-error
         ~notify-title
         (r/r :fatal "Exception!" {:details ex}))
       (System/exit 1))))



(comment
  (load-if-file "deps.edn")
  (file-name-sans-ext "abc/def/thefile.txt"))
