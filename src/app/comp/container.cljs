
(ns app.comp.container
  (:require [hsl.core :refer [hsl]]
            [respo-ui.core :as ui]
            [respo.core
             :refer
             [defcomp cursor-> mutation-> list-> <> div button textarea span a video]]
            [respo.comp.space :refer [=<]]
            [reel.comp.reel :refer [comp-reel]]
            [respo-md.comp.md :refer [comp-md]]
            [app.config :refer [dev?]]
            [feather.core :refer [comp-icon comp-i]]
            [clojure.tools.reader :refer [read-string]]
            [shadow.resource :refer [inline]])
  (:require-macros [clojure.core.strint :refer [<<]]))

(def style-control-bar
  (merge
   ui/row-parted
   {:position :fixed,
    :top 0,
    :left 0,
    :height 80,
    :width "100%",
    :background-color (hsl 0 0 40 0.5),
    :border-top (<< "1px solid ~{(hsl 0 0 60)}")}))

(def videos (read-string (inline "entries.edn")))

(defcomp
 comp-container
 (reel)
 (let [store (:store reel)
       states (:states store)
       state (or (:data states) {:show-control? true, :show-list? false, :playing-idx 0})]
   (div
    {:style (merge
             ui/global
             ui/fullscreen
             ui/center
             {:background-color :black, :position :relative}),
     :on-click (mutation-> (-> state (update :show-control? not)))}
    (video
     {:src (str "videos/" (get videos (or (:playing-idx state) 0))),
      :playback-rate 1.2,
      :style {:max-width "100%", :max-height "100%"},
      :controls (:show-control? state),
      :autoplay true})
    (when (:show-control? state)
      (div
       {:style style-control-bar}
       (div
        {:style (merge ui/row-middle {:padding "0 16px"})}
        (a
         {:style {:color :white, :font-size 40},
          :on-click (mutation-> (assoc state :show-list? true))}
         (comp-i :menu 14 (hsl 200 80 80)))
        (=< 40 nil)
        (a
         {:style {:color :white, :font-size 40},
          :on-click (mutation-> (update state :playing-idx inc))}
         (comp-i :arrow-left 14 (hsl 200 80 80)))
        (=< 40 nil)
        (a
         {:style {:color :white, :font-size 40},
          :on-click (mutation-> (update state :playing-idx dec))}
         (comp-i :arrow-right 14 (hsl 200 80 80))))))
    (when (:show-list? state)
      (div
       {:style (merge ui/fullscreen ui/center {:z-index 1000}),
        :on-click (mutation-> (assoc state :show-list? false))}
       (div
        {:style {:width 600,
                 :height 400,
                 :background-color (hsl 0 0 0 0.6),
                 :color :white,
                 :overflow :auto},
         :on-click (fn [e d! m!] )}
        (list->
         {:style {:padding "16px 0"}}
         (->> videos
              (map-indexed
               (fn [idx video-name]
                 [video-name
                  (div
                   {:style (merge
                            {:padding "0 16px", :font-size 20, :line-height "40px"}
                            (when (= idx (or (:playing-idx state) 0))
                              {:background-color (hsl 0 0 100 0.2)})),
                    :on-click (fn [e d! m!] (m! (assoc state :playing-idx idx)))}
                   (<> video-name))]))))))))))
