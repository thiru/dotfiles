(ns scripts.cljcfg.hyprlang
  "A library to convert Clojure data-structures to Hyprlang.
  See: https://wiki.hyprland.org/Hypr-Ecosystem/hyprlang/"
  (:require [clojure.spec.alpha :as s]
            [clojure.string :as str]
            [scripts.specin :refer [apply-specs s< s>]]
            [scripts.utils :as u]))

(declare ->hyprlang-category)

(def auto-gen-note
  (str "# NOTE: this file is auto-generated.\n"
       "# To make changes please modify the Clojure source file instead.\n\n"))

;;; Define some bindings to common commands for the following reasons:
;;; - it looks cleaner in the config data-structure (i.e. no single quote or colon prefix such as
;;;   is needed with symbols and keywords)
;;; - we get doc info
(def ^{:doc "Create an input binding"} bind 'bind)
(def ^{:doc "Create an input binding with a description"} bindd 'bindd)
(def ^{:doc "Unbind an input binding"} unbind 'unbind)
(def ^{:doc "Create an environment variable"} env 'env)
(def ^{:doc "Execute command on each config reload"} exec 'exec)
(def ^{:doc "Execute command only on launch"} exec-once 'exec-once)
(def ^{:doc "Define monitor config"} monitor 'monitor)
(def ^{:doc "Define a keybind submap (aka a mode or group)"} submap 'submap)
(def ^{:doc "Define a window rule"} windowrule 'windowrule)
(def ^{:doc "Define a workspace rule"} workspace 'workspace)

(defn ->hyprlang-name
  "Convert the given object into a Hyprlang-friendly command name."
  {:args (s< :arg any?)
   :ret  (s> string?)}
  [arg]
  (cond
    (nil? arg)
    ""

    (or (keyword? arg) (symbol? arg))
    (name arg)

    :else
    (str arg)))

(defn ->hyprland-config-line
  "Convert the given map entry into a Hyprlang config line. E.g.:
  command = value"
  {:args (s< :cat map-entry?
             :indent (s/? number?))
   :ret  (s> string?)}
  ([kvp]
   (->hyprland-config-line kvp 0))
  ([kvp indent]
   (let [k (key kvp)
         v (val kvp)]
     (if (map? v)
       (->hyprlang-category kvp indent)
       (-> (format "%s = %s"
                   (->hyprlang-name k)
                   (if (sequential? v)
                     (->> (map ->hyprlang-name  v)
                          (str/join ", "))
                     (->hyprlang-name v)))
           (u/indent-line indent))))))

(defn ->hyprlang-category
  "Convert the given map entry into a Hyprlang category. E.g.:
  category { variable = value }"
  {:args (s< :cat map-entry?
             :indent (s/? number?))
   :ret  (s> string?)}
  ([cat]
   (->hyprlang-category cat 0))
  ([cat indent]
   (let [cat-name (key cat)
         cat-val (val cat)]
     (str (u/indent-line (->hyprlang-name cat-name) indent)
          " {\n"
          (loop [curr-kvp (first cat-val)
                 rest-kvps (rest cat-val)
                 config-opts []]
            (if (nil? curr-kvp)
              (str/join "\n" config-opts)
              (recur (first rest-kvps)
                     (rest rest-kvps)
                     (conj config-opts
                           (->hyprland-config-line curr-kvp (+ 2 indent))))))
          "\n"
          (u/indent-line "}" indent)))))

(defn ->hyprland-config
  "Generate a Hyprland config for the given data-structure."
  {:args (s< :data vector?)
   :ret  (s> string?)}
  [input]
  (->> input
       (map first)
       (map ->hyprland-config-line)
       (str/join "\n")
       (str auto-gen-note)))

(apply-specs)

(comment
  (->> [{bind [:SUPER :Q :killactive]}
        {bindd [:SUPER :T "Description of binding" :submap :GROUP]}
        {'bindel [nil :XF86AudioMute :exec "sh vol-script mute"]}
        {:unbind [:SUPER :O]}
        {env [:XDG_CURRENT_DESKTOP :Hyprland]}
        {exec "sh some-script"}
        {exec-once "hypridle"}
        {monitor [nil :preferred :auto :auto]}
        {submap :reset}
        {windowrule ["suppressevent maximize" "class:.*"]}
        {'input {'kb_layout :us
                 'follow_mouse 1
                 'touchpad {'natural_scroll false
                            'scroll_factor 1.2}}}]
       ->hyprland-config
       println))
