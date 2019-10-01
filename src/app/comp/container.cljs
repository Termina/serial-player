
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

(defcomp
 close-button
 (handler)
 (a
  {:style {:color :white, :cursor :pointer}, :on-click (fn [e d! m!] (handler d! m!))}
  (comp-i :x 20 (hsl 0 80 60))))

(defn render-link [icon handler]
  (a
   {:style {:color :white, :cursor :pointer}, :on-click (fn [e d! m!] (handler d! m!))}
   (comp-i icon 18 (hsl 200 80 80))))

(defcomp
 speed-link
 (speed selected?)
 (a
  {:style (merge
           {:color (hsl 0 0 80),
            :font-size 14,
            :font-family ui/font-code,
            :margin "0 14px",
            :cursor :pointer,
            :display :inline-block}
           (if selected? {:color :white, :transform "scale(1.2)"})),
   :on-click (fn [e d! m!] (d! :speed speed)),
   :inner-text (str "x" speed)}))

(def style-control-bar
  {:position :fixed,
   :bottom 0,
   :left 0,
   :height 64,
   :width "100%",
   :background-color (hsl 0 0 0 0.8),
   :border-top (<< "1px solid " (hsl 0 0 80 0.4)),
   :padding "0 20px",
   :z-index 100})

(defcomp
 comp-header
 (store)
 (div
  {:style (merge ui/row-parted style-control-bar)}
  (div
   {:style (merge ui/row-middle {:padding "0 16px"})}
   (render-link :menu (fn [d!] (d! :toggle-list nil)))
   (=< 40 nil)
   (render-link :skip-back (fn [d!] (d! :dec-index nil)))
   (=< 40 nil)
   (render-link :skip-forward (fn [d!] (d! :inc-index nil)))
   (=< 40 nil)
   (render-link
    :chevrons-left
    (fn [e d! m!]
      (let [v (js/document.querySelector "video")]
        (set! (.-currentTime v) (- (.-currentTime v) 10)))))
   (=< 40 nil)
   (render-link
    :chevrons-right
    (fn [e d! m!]
      (let [v (js/document.querySelector "video")]
        (set! (.-currentTime v) (+ 10 (.-currentTime v)))))))
  (div
   {:style ui/row-middle}
   (speed-link 1 (= 1 (:speed store)))
   (speed-link 1.4 (= 1.4 (:speed store)))
   (speed-link 2 (= 2 (:speed store)))
   (=< 40 nil)
   (close-button (fn [d!] (d! :toggle-control nil))))))

(def videos (read-string (inline "entries.edn")))

(defcomp
 comp-videos-list
 (video-index)
 (div
  {:style (merge ui/fullscreen ui/center {:z-index 1000, :background-color (hsl 0 0 0 0.4)}),
   :on-click (fn [e d! m!] (comment d! :toggle-list nil))}
  (div
   {:style (merge
            ui/column
            {:width 600, :height 400, :background-color (hsl 0 0 0 0.6), :color :white}),
    :on-click (fn [e d! m!] )}
   (div
    {:style (merge ui/row-parted {})}
    (span nil)
    (comp-icon
     :x
     {:color (hsl 0 80 80), :font-size 20, :margin 10, :cursor :pointer}
     (fn [e d! m!] (d! :toggle-list nil))))
   (list->
    {:style (merge ui/expand {:padding "16px 0", :overflow :auto})}
    (->> videos
         (map-indexed
          (fn [idx video-name]
            [video-name
             (div
              {:style (merge
                       {:padding "0 16px", :font-size 20, :line-height "40px"}
                       (when (= idx (or video-index 0))
                         {:background-color (hsl 0 0 100 0.2)})),
               :on-click (fn [e d! m!] (d! :change-index idx))}
              (<> video-name))])))))))

(defcomp
 comp-container
 (reel)
 (let [store (:store reel), states (:states store), speed (or (:speed store) 1)]
   (div
    {:style (merge
             ui/global
             ui/fullscreen
             ui/center
             {:background-color :black, :position :relative, :user-select :none})}
    (video
     {:src (str "videos/" (get videos (or (:playing-idx store) 0))),
      :playback-rate speed,
      :style {:max-width "100%", :max-height "100%", :outline :none},
      :controls (or true (not (:show-control? store))),
      :autoplay true,
      :on-click (fn [e d! m!] (.stopPropagation (:event e)))})
    (if (:show-control? store)
      (comp-header store)
      (div
       {:style {:position :absolute,
                :right 20,
                :bottom 20,
                :padding 10,
                :opacity 0.4,
                :background-color (hsl 0 0 0 0.4),
                :border-radius 6,
                :z-index 100,
                :cursor :pointer},
        :on-click (fn [e d! m!] (d! :toggle-control nil))}
       (comp-i :command 18 (hsl 0 0 100))))
    (when (:show-list? store) (comp-videos-list (:playing-idx store))))))
