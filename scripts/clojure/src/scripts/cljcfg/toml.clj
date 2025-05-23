(ns scripts.cljcfg.toml
  "A library to create TOML config from Clojure data-structures."
  (:require [clojure.spec.alpha :as s]
            [clojure.string :as str]
            [scripts.specin :refer [apply-specs s< s>]]
            [scripts.utils :as u]))

(defn safe-key-name
  "Generate a safe string for a key.
  I.e. surround it in quotes when there are non-word chars."
  {:args (s< :k (s/or :keyword keyword?
                      :string string?))
   :ret  (s> string?)}
  [k]
  (let [k-name (-> k name)
        unsafe? (re-find #"[^\w]" k-name)]
    (if unsafe?
      (str "\"" k-name "\"")
      k-name)))

(defn kvp-val->str
  "Generate string for the value of a key."
  {:args (s< :kvp-val any?)
   :ret  (s> string?)}
  [kvp-val]
  (cond
    (string? kvp-val)
    (str "\"" kvp-val "\"")

    (keyword? kvp-val)
    (name kvp-val)

    (boolean? kvp-val)
    (str kvp-val)

    (number? kvp-val)
    (str kvp-val)

    (vector? kvp-val)
    (->> (mapv kvp-val->str kvp-val)
         (str/join ", ")
         (u/surround "[" "]"))

    (map? kvp-val)
    (->> (for [[k v] kvp-val]
           (format "%s = %s"
                   (safe-key-name k)
                   (kvp-val->str v)))
         (str/join ", ")
         (u/surround "{" "}"))

    :else
    (do
      (u/println-stderr (format "Warning: unhandled case for '%s' (type %s)"
                                kvp-val
                                (type kvp-val)))
      (str "\"" kvp-val "\""))))

(defn kvp-node->str
  "Generate string for a key-value pair."
  {:args (s< :kvp map-entry?)
   :ret  (s> string?)}
  [kvp]
  (format "%s = %s"
          (safe-key-name (key kvp))
          (kvp-val->str (val kvp))))

(defn category->str
  "Generate string for an entire category."
  {:args (s< :kvp map-entry?)
   :ret  (s> string?)}
  [kvp]
  (format "\n[%s]\n%s"
          (-> kvp key name)
          (->> (val kvp)
               (mapv kvp-node->str)
               (str/join "\n"))))

(defn top-level->str
  "Generate string for a top-level key-value pair."
  {:args (s< :node map?)
   :ret  (s> string?)}
  [node]
  (let [kvp (first node)]
    (if (map? (val kvp))
      (category->str kvp)
      (kvp-node->str kvp))))

(defn ->toml
  "Generate a TOML string for the given data-structure."
  {:args (s< :data vector?)
   :ret  (s> string?)}
  [data]
  (->> data
       (map top-level->str)
       (str/join "\n")))

(comment
  (-> [{:$schema "http://abc.com"}
       {:cat1 {:cat1_k1 "cat1-v1"
               :cat1_k2 22
               :cat1_k3 [3 4 5]}}
       {:cat2 {:cat2-k1 123
               :cat2-k2 {:a 1 :b 2 :c$ "three"}}}]
      (->toml)
      println))

(apply-specs)
