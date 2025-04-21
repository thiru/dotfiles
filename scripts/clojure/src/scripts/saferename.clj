#!/usr/bin/env bb

(ns scripts.saferename
  "Rename the given file (name excluding extension) to one that can be safely used in any OS. I.e.
  without any special characters and while preserving non-ASCII dashes and quotes."
  (:require
            [clojure.java.io :as io]
            [clojure.string :as str]
            [scripts.results :as r]
            [scripts.utils :as u]))


(def usage "Usage: saferename.clj FILE NEW-NAME")

(defn validate-args [args]
  (cond
    (or (empty? args) (not= 2 (count args)))
    (r/r :error (format "Expected 2 arguments but got %d\n%s"
                        (count args)
                        usage))

    (str/blank? (first args))
    (r/r :error "No file provided")

    (str/blank? (second args))
    (r/r :error "Target filename not provided")

    :else
    (r/r :success "Arguments are valid" {:input-file {:path (first args)}
                                         :target-file {:original-name (second args)}})))

(defn load-file-r [last-r]
  (merge last-r
         (u/load-if-file (-> last-r :input-file :path))))

(defn extract-file-info [last-r]
  (let [path-obj (-> last-r :file .toPath)
        full-file-name (-> path-obj .getFileName .toString)
        file-name (u/file-name-sans-ext full-file-name)]
    (-> last-r
        (assoc :message "File info extracted")
        (update :input-file
                #(assoc %
                        :name file-name
                        :ext (subs full-file-name (count file-name))
                        :parent-dir (or (some-> path-obj .getParent .toString) "")))
        (dissoc :file))))

(defn sanitise-file-name [last-r]
  (-> last-r
      (assoc-in [:target-file :sanitised-name]
                (-> (-> last-r :target-file :original-name)
                    ;; Replace m-dash and n-dash with a regular dash
                    (str/replace #"—|–" "-")
                    ;; Replace colon with dash and add space around it
                    (str/replace #"\s*:\s*" " - ")
                    ;; Replace tab character with underscore
                    (str/replace #"\t" "_")
                    ;; Replace curly single quotes with regular single quotes
                    (str/replace #"‘|’" "'")
                    ;; Replace curly double quotes with regular double quotes
                    (str/replace #"“|”" "'")
                    ;; Strip out all other unusual characters
                    (str/replace #"[^\w-&\s'\"]" "")
                    ;; Remove contiguous whitespace
                    (str/replace #"\s\s+" " ")))
      (assoc :message "Sanitised target filename")))

(defn rename-file [last-r]
  (let [src-file (io/file (-> last-r :input-file :path))
        parent-dir (-> last-r :input-file :parent-dir)
        ;; NOTE: if parent-dir is an empty string it will resolve to the root folder for some
        ;; reason. Making it nil will make it so that the file doesn't have a parent-dir and so it
        ;; will be relative to the CWD.
        parent-dir (if (empty? parent-dir) nil parent-dir)
        tgt-file (io/file parent-dir
                          (str (-> last-r :target-file :sanitised-name)
                               (-> last-r :input-file :ext)))
        renamed? (.renameTo src-file tgt-file)]
    (if renamed?
      (let [old-name (.toString src-file)
            new-name (.toString tgt-file)
            stripped-chars (- (count (-> last-r :target-file :original-name))
                              (count (-> last-r :target-file :sanitised-name)))]
        (assoc last-r
               :level :success
               :message (str (format "Renamed file:\nOLD: '%s':\nNEW: '%s'" old-name new-name)
                             (if (zero? stripped-chars)
                               ""
                               (format "\nRemoved %d unsafe chars" stripped-chars)))))
      (assoc last-r
             :level :error
             :message "Failed to rename file"))))

(defn print-and-exit [last-r]
  (r/print-msg last-r)
  (when (u/bb-cli?)
    (System/exit (if (r/success? last-r) 0 1))))

(defn -main [& args]
  (print-and-exit
    (r/while-success-> (validate-args args)
                       load-file-r
                       extract-file-info
                       sanitise-file-name
                       rename-file)))

(when (u/bb-cli?)
  (apply -main *command-line-args*))



(comment
  (-main (str (System/getenv "HOME") "/test.txt")
         "123	A_B_C: Lorem—ipsum & dolor – sit, <> ‘amit’ “adipiscing” elit..."))
