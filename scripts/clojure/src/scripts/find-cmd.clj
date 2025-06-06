#!/usr/bin/env bb

#_{:clj-kondo/ignore [:namespace-name-mismatch]}
(ns scripts.find-cmd
  "Find a command/script with a help description."
  (:require [babashka.fs :as fs]
            [babashka.process :as bp]
            [cheshire.core :as json]
            [clojure.java.shell :refer [sh]]
            [clojure.spec.alpha :as s]
            [clojure.string :as str]
            [sci.core :as sci]
            [scripts.results :as r]
            [scripts.utils :as u]
            [scripts.specin :refer [apply-specs s< s>]]))

(def usage "Usage: find-cmd.clj <fzf|walker> [PATHS]")

(def terminal-cmd "neovide -- --cmd 'lua vim.g.nvtmux_auto_start = true' --cmd 'lua vim.g.nvtmux_auto_start_cmd = \"confirm-quit %s\"'")
; (def terminal-cmd "kitty --hold %s") ; A simpler alternative

(s/def ::java-file #(instance? java.io.File %))
(s/def ::file-type string?)
(s/def ::help string?)
(s/def ::script-info (s/keys :req-un [::java-file ::file-type] :opt-un [::help]))

(defn get-file-type
  "Determine the (mime) type of the given file."
  {:args (s< :file ::file)
   :ret  (s> (s/or :success ::file-type
                   :failure str/blank?))}
  [file]
  (let [cmd-res (sh "file" "--brief" "--dereference" "--mime" (fs/unixify file))]
    (if (zero? (:exit cmd-res))
      (:out cmd-res)
      (do
        (u/println-stderr (str "Failed to determine file type of " (fs/unixify file) " " cmd-res))
        ""))))

(defn text-file?
  "Determine if the given file type is text."
  {:args (s< :file-type ::file-type)
   :ret  (s> boolean?)}
  [file-type]
  (-> file-type (str/starts-with? "text/")))

(defn get-scripts
  "Get fully qualified paths and their types to all scripts in the given list of dirs."
  {:args (s< :dirs (s/coll-of string?))
   :ret  (s> ::script-info)}
  [dirs]
  (some->> dirs
           (map fs/list-dir)
           flatten
           (filter fs/regular-file?)
           (filter fs/readable?)
           (filter fs/executable?)
           (map fs/canonicalize)
           (map fs/absolutize)
           (map #(assoc {} :java-file % :file-type (get-file-type %)))
           (filter #(text-file? (:file-type %)))))

(defn found-scripts?
  "Check if any scripts were found. We want to exit early if not."
  {:args (s< :script-infos (s/coll-of ::script-info))
   :ret  (s> ::r/result)}
  [script-infos]
  (if (empty? script-infos)
    (r/r :error "No scripts found")
    script-infos))

(defn parse-help-clojure
  "Parse help from the given Clojure source file."
  {:args (s< :file ::java-file)
   :ret  (s> ::help)}
  [file]
  (let [clj-src (str/join "\n" (fs/read-all-lines file))
        ;; NOTE: I'm assuming that the `ns` form is the first form in the source file, as the
        ;; following will only read the first form
        first-form (sci/parse-string (sci/init {}) clj-src)
        help (nth first-form 2)]
    (if (and (= 'ns (first first-form))
             (string? help))
      (-> help str/trim (str/replace "\n" ""))
      "")))

(defn parse-help-python
  "Parse help from the given Python source file."
  {:args (s< :file ::java-file)
   :ret  (s> ::help)}
  [file]
  (let [lines (fs/read-all-lines file)]
    (loop [rest-lines lines
           curr-line (first lines)
           doc-line nil]
      (if (or doc-line (nil? curr-line))
        (str/trim (or doc-line ""))
        (recur (rest rest-lines)
               (first rest-lines)
               (second (re-find #"\s*\"\"\"(.*)" curr-line)))))))

(defn parse-help-shell
  "Parse help from the given shell script."
  {:args (s< :file ::java-file)
   :ret  (s> ::help)}
  [file]
  (let [lines (fs/read-all-lines file)]
    (loop [rest-lines lines
           curr-line (first lines)
           doc-line nil]
      (if (or doc-line (nil? curr-line))
        (str/trim (or doc-line ""))
        (recur (rest rest-lines)
               (first rest-lines)
               (second (re-find #"\s*#[^!](.*)" curr-line)))))))

(defn read-help
  "Associate `::help` with the given scripts."
  {:args (s< :script-infos (s/coll-of ::script-info))
   :ret  (s> (s/coll-of ::script-info))}
  [script-infos]
  (mapv
    #(assoc %
            :help
            (cond
              (str/includes? (:file-type %) "clojure")
              (parse-help-clojure (:java-file %))

              (str/includes? (:file-type %) "python")
              (parse-help-python (:java-file %))

              (str/includes? (:file-type %) "shellscript")
              (parse-help-shell (:java-file %))

              :else
              (parse-help-shell (:java-file %))))
    script-infos))

(defn script-infos->fzf-input
  "Convert the script metadata maps to FZF-friendly input."
  {:args (s< :script-infos (s/coll-of ::script-info))
   :ret  (s> (s/coll-of string?))}
  [script-infos]
  (mapv #(let [help (:help %)
               help (if (str/blank? help)
                      "..."
                      help)]
           (format "%s | %s"
                  (-> % :java-file (fs/file-name))
                  help))
        script-infos))

(defn run-fzf
  "Run FZF with the given script infos."
  {:args (s< :fzf-input string?)
   :ret  (s> (s/or :success string?
                   :failure ::r/result))}
  [fzf-input]
  (let [opts {:in (str/join "\n" fzf-input)
              :out :string
              :err :out
              :continue true}
        cmd-res (bp/shell opts "fzf")]
    (if (zero? (:exit cmd-res))
      (:out cmd-res)
      (let [err-msg (if (str/blank? (:out cmd-res))
                      "Seems like no command was selected"
                      (:out cmd-res))]
        (r/r :error err-msg)))))

(defn get-selected-script
  {:args (s< :selection string?)
   :ret  (s> (s/or :success string?
                   :failure ::r/result))}
  [selection]
  (let [script (-> selection (str/split #"\|") first str/trim)]
    (if (str/blank? script)
      (r/r :error "Failed to parse script name from selection")
      script)))

(defn run-selected-script
  {:args (s< :script string?)
   :ret  (s> ::r/result)}
  [script]
  (let [cmd-res (bp/shell {:continue :true :out :string :err :out} script)]
    (if (zero? (:exit cmd-res))
      (r/r :success (str "Successfully ran script: " script))
      (r/r :error (str "Script failed: " (:out cmd-res))))))

(defn script-infos->walker-entries
  "Convert the script metadata maps to a format expected by the walker launcher."
  {:args (s< :script-infos (s/coll-of ::script-info))
   :ret  (s> (s/coll-of string?))}
  [script-infos]
  (mapv #(let [help (:help %)
               help (if (str/blank? help)
                      "..."
                      help)
               file-name (-> % :java-file (fs/file-name))]
           (assoc {}
                  :exec (format terminal-cmd file-name)
                  :label (format "%s | %s" file-name help)))
        script-infos))

(defn print-walker-entries
  "TODO"
  [entries]
  (println (json/generate-string entries))
  (r/r :success "walker entries printed"))

(defn run-cmd
  "Run this command."
  {:args (s< :args (s/coll-of string?))
   :ret  (s> ::r/result)}
  [args]
  (let [sub-cmd (first args)
        paths (or (rest args) ["."])]
    (case sub-cmd
      ("-h" "--help")
      (u/show-help usage)

      ("walker")
      (r/while-success-> (get-scripts paths)
                         found-scripts?
                         read-help
                         script-infos->walker-entries
                         print-walker-entries)

      ("fzf")
      (r/while-success-> (get-scripts paths)
                         found-scripts?
                         read-help
                         script-infos->fzf-input
                         run-fzf
                         get-selected-script
                         run-selected-script)

      (nil "")
      (do
        (println usage)
        (System/exit 1))

      (do
        (u/println-stderr "Unexpected sub-command:" sub-cmd)
        (System/exit 1)))))

(defn -main [& args]
  (u/safe-run-exit "Find Command" (run-cmd args)))

(when (u/bb-cli?)
  (apply -main *command-line-args*))

(apply-specs)
