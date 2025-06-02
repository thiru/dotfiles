#!/usr/bin/env bb

(ns yazi
  "Generate yazi configs."
  (:require [scripts.cljcfg.toml :as cfg]
            [scripts.specin :refer [apply-specs s< s>]]
            [scripts.utils :as u]))

(def envs {:default
           {:ueberzug-offset [10 0 0 0]
            :ueberzug-scale 1}
           :tmed
           {:ueberzug-offset [20 0 0 0]
            :ueberzug-scale 2}})

(defn gen-config
  "A TOML linter such as https://taplo.tamasfe.dev/ can use the schema below to validate this
  config."
  {:args (s< :env map?)
   :ret  (s> vector?)}
  [env]
  [{:$schema "https://yazi-rs.github.io/schemas/yazi.json"}

   {:mgr
    {:linemode "size"}}

   {:preview
    {:cache_dir "~/.cache/yazi"
     :max_height 1500
     :max_width 1200
     :ueberzug_offset (-> env :ueberzug-offset)
     :ueberzug_scale (-> env :ueberzug-scale)}}])

(defn gen-configs
  "Generate a config for each environment."
  []
  (doseq [env envs]
    (let [file-name (format "yazi.%s.toml" (-> env key name))]
      (->> (gen-config (val env))
           (cfg/->toml)
           (spit file-name))
      (println "Generated config:" file-name))))

(when (u/bb-cli?)
  (gen-configs))

(apply-specs)
