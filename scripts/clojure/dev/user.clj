(ns user

  "Initial namespace loaded when launching a REPL for Clojure source in the
  scripts/ folder."

  {:clj-kondo/config '{:linters {:unused-namespace {:level :off}
                                 :unused-referred-var {:level :off}}}}
  (:require
            [clojure.java.io :as io]
            [clojure.pprint :refer :all]
            [clojure.repl :refer :all]
            [clojure.reflect :as reflect]
            [clojure.spec.alpha :as s]
            [clojure.string :as str]
            [puget.printer :as puget]
            [rebel-readline.main :as rebel]
            [scripts.brightness :as brightness]
            [scripts.power :as power]
            [scripts.results :as r]
            [scripts.utils :as u]
            [scripts.vol :as vol]
            [utils.nrepl :as nrepl]
            [utils.printing :as printing :refer [PP]]))


(defonce initialised? (atom false))

(when (not @initialised?)
  (reset! initialised? true)
  (printing/install-expound-printer)
  (nrepl/start-server)
  ;; Blocking call:
  (rebel/-main)
  (nrepl/stop-server)
  ;; HACK: rebel-readline causes process to hang and not quit without this:
  (System/exit 0))
