
(ns app.comp.container
  (:require [hsl.core :refer [hsl]]
            [respo-ui.core :as ui]
            [respo.macros
             :refer
             [defcomp cursor-> action-> mutation-> list-> <> div button textarea span a]]
            [respo.comp.space :refer [=<]]
            [reel.comp.reel :refer [comp-reel]]
            [respo-md.comp.md :refer [comp-md]]
            [app.config :refer [dev?]]
            [app.macros :refer [video]]
            [respo-ui.comp.icon :refer [comp-icon]]
            [clojure.tools.reader :refer [read-string]])
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

(def videos
  (read-string
   "[\n  \"SAO/01.mp4\"\n  \"SAO/02.mp4\"\n  \"SAO/03.mp4\"\n  \"SAO/04.mp4\"\n  \"SAO/05.mp4\"\n  \"SAO/06.mp4\"\n  \"SAO/07.mp4\"\n  \"SAO/08.mp4\"\n  \"SAO/09.mp4\"\n  \"SAO/10.mp4\"\n  \"SAO/11.mp4\"\n  \"SAO/12.mp4\"\n  \"SAO/13.mp4\"\n  \"SAO/14.mp4\"\n  \"SAO/15.mp4\"\n  \"SAO/16.mp4\"\n  \"SAO/17.mp4\"\n  \"SAO/18.mp4\"\n  \"SAO/19.mp4\"\n  \"SAO/20.mp4\"\n  \"SAO/21.mp4\"\n  \"SAO/22.mp4\"\n  \"SAO/23.mp4\"\n  \"SAO/24.mp4\"\n  \"SAO/25.mp4\"\n  \"SAO2/01.mp4\"\n  \"SAO2/02.mp4\"\n  \"SAO2/03.mp4\"\n  \"SAO2/04.mp4\"\n  \"SAO2/05.mp4\"\n  \"SAO2/06.mp4\"\n  \"SAO2/07.mp4\"\n  \"SAO2/08.mp4\"\n  \"SAO2/09.mp4\"\n  \"SAO2/10.mp4\"\n  \"SAO2/11.mp4\"\n  \"SAO2/12.mp4\"\n  \"SAO2/13.mp4\"\n  \"SAO2/14.mp4\"\n  \"SAO2/15.mp4\"\n  \"SAO2/16.mp4\"\n  \"SAO2/17.mp4\"\n  \"SAO2/18.mp4\"\n  \"SAO2/19.mp4\"\n  \"SAO2/20.mp4\"\n  \"SAO2/21.mp4\"\n  \"SAO2/22.mp4\"\n  \"SAO2/23.mp4\"\n  \"SAO2/24.mp4\"\n]\n"))

(defcomp
 comp-container
 (reel)
 (let [store (:store reel)
       states (:states store)
       state (or (:data states) {:show-control? false, :show-list? false, :playing-idx 0})]
   (div
    {:style (merge
             ui/global
             ui/fullscreen
             ui/center
             {:background-color :black, :position :relative}),
     :on-click (mutation-> (-> state (update :show-control? not)))}
    (video
     {:src (str "videos/" (get videos (or (:playing-idx state) 0))),
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
         (comp-icon :android-menu))
        (=< 40 nil)
        (a
         {:style {:color :white, :font-size 40},
          :on-click (mutation-> (update state :playing-idx inc))}
         (comp-icon :arrow-right-a))
        (=< 40 nil)
        (a
         {:style {:color :white, :font-size 40},
          :on-click (mutation-> (update state :playing-idx dec))}
         (comp-icon :arrow-left-a)))))
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
