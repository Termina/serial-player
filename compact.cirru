
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/ |respo-feather.calcit/
    :version nil
  :files $ {}
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require
          [] respo-ui.core :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> list-> <> div button textarea span a create-element
          [] respo.comp.space :refer $ [] =<
          [] reel.comp.reel :refer $ [] comp-reel
          [] respo-md.comp.md :refer $ [] comp-md
          [] app.config :refer $ [] dev?
          [] feather.core :refer $ [] comp-icon comp-i
      :defs $ {}
        |render-link $ quote
          defn render-link (icon handler)
            a
              {}
                :style $ {} (:color :white) (:cursor :pointer)
                :on-click $ fn (e d!) (handler d!)
              comp-i icon 18 $ hsl 200 80 80
        |speed-link $ quote
          defcomp speed-link (speed selected?)
            a $ {}
              :style $ merge
                {}
                  :color $ hsl 0 0 80
                  :font-size 14
                  :font-family ui/font-code
                  :margin "\"0 14px"
                  :cursor :pointer
                  :display :inline-block
                if selected? $ {} (:color :white) (:transform "\"scale(1.2)")
              :on-click $ fn (e d! m!) (d! :speed speed)
              :inner-text $ str "\"x" speed
        |comp-container $ quote
          defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
                speed $ or (:speed store) 1
              div
                {} $ :style
                  merge ui/global ui/fullscreen ui/center $ {} (:background-color :black) (:user-select :none)
                create-element :video $ {}
                  :src $ str "\"videos/"
                    get videos $ or (:playing-idx store) 0
                  :playback-rate speed
                  :style $ {} (:max-width "\"100%") (:max-height "\"100%") (:outline :none)
                  :controls $ or true
                    not $ :show-control? store
                  :autoplay true
                  :on-click $ fn (e d!)
                    .stopPropagation $ :event e
                if (:show-control? store) (comp-header store)
                  div
                    {}
                      :style $ {} (:position :absolute) (:right 20) (:bottom 20) (:padding 10) (:opacity 0.4)
                        :background-color $ hsl 0 0 0 0.4
                        :border-radius 6
                        :z-index 100
                        :cursor :pointer
                      :on-click $ fn (e d!) (d! :toggle-control nil)
                    comp-i :command 18 $ hsl 0 0 100
                when (:show-list? store)
                  comp-videos-list $ :playing-idx store
        |close-button $ quote
          defcomp close-button (handler)
            a
              {}
                :style $ {} (:color :white) (:cursor :pointer)
                :on-click $ fn (e d!) (handler d!)
              comp-i :x 20 $ hsl 0 80 60
        |style-control-bar $ quote
          def style-control-bar $ {} (:position :fixed) (:bottom 0) (:left 0) (:height 64) (:width "\"100%")
            :background-color $ hsl 0 0 0 0.8
            :border-top $ str "\"1px solid " (hsl 0 0 80 0.4)
            :padding "\"0 20px"
            :z-index 100
        |comp-header $ quote
          defcomp comp-header (store)
            div
              {} $ :style (merge ui/row-parted style-control-bar)
              div
                {} $ :style
                  merge ui/row-middle $ {} (:padding "\"0 16px")
                render-link :menu $ fn (d!) (d! :toggle-list nil)
                =< 40 nil
                render-link :skip-back $ fn (d!) (d! :dec-index nil)
                =< 40 nil
                render-link :skip-forward $ fn (d!) (d! :inc-index nil)
                =< 40 nil
                render-link :chevrons-left $ fn (e d!)
                  let
                      v $ js/document.querySelector "\"video"
                    set! (.-currentTime v)
                      - (.-currentTime v) 10
                =< 40 nil
                render-link :chevrons-right $ fn (e d!)
                  let
                      v $ js/document.querySelector "\"video"
                    set! (.-currentTime v)
                      + 10 $ .-currentTime v
              div
                {} $ :style ui/row-middle
                speed-link 1 $ = 1 (:speed store)
                speed-link 1.4 $ = 1.4 (:speed store)
                speed-link 2 $ = 2 (:speed store)
                =< 40 nil
                close-button $ fn (d!) (d! :toggle-control nil)
        |comp-videos-list $ quote
          defcomp comp-videos-list (video-index)
            div
              {}
                :style $ merge ui/fullscreen ui/center
                  {} (:z-index 1000)
                    :background-color $ hsl 0 0 0 0.4
                :on-click $ fn (e d!) (; d! :toggle-list nil)
              div
                {}
                  :style $ merge ui/column
                    {} (:width 600) (:height 400)
                      :background-color $ hsl 0 0 0 0.6
                      :color :white
                  :on-click $ fn (e d!)
                div
                  {} $ :style
                    merge ui/row-parted $ {}
                  span nil
                  comp-icon :x
                    {}
                      :color $ hsl 0 80 80
                      :font-size 20
                      :margin 10
                      :cursor :pointer
                    fn (e d!) (d! :toggle-list nil)
                list->
                  {} $ :style
                    merge ui/expand $ {} (:padding "\"16px 0") (:overflow :auto)
                  -> videos $ map-indexed
                    fn (idx video-name)
                      [] video-name $ div
                        {}
                          :style $ merge
                            {} (:padding "\"0 16px") (:font-size 20) (:line-height "\"40px")
                            when
                              = idx $ or video-index 0
                              {} $ :background-color (hsl 0 0 100 0.2)
                          :on-click $ fn (e d!) (d! :change-index idx)
                        <> video-name
        |inline $ quote
          defmacro inline (path)
            read-file $ str "\"index/" path
        |videos $ quote
          def videos $ parse-cirru-edn (inline "\"entries.cirru")
    |app.schema $ {}
      :ns $ quote (ns app.schema)
      :defs $ {}
        |store $ quote
          def store $ {}
            :states $ {}
            :speed 1
            :show-control? true
            :show-list? false
            :playing-idx 0
    |app.updater $ {}
      :ns $ quote
        ns app.updater $ :require
          [] respo.cursor :refer $ [] update-states
      :defs $ {}
        |updater $ quote
          defn updater (store op op-data op-id op-time)
            case-default op
              do (println "\"Unknown op:" op) store
              :states $ update-states store op-data
              :hydrate-storage op-data
              :change-index $ assoc store :playing-idx op-data
              :inc-index $ update store :playing-idx inc
              :dec-index $ update store :playing-idx dec
              :toggle-control $ update store :show-control? not
              :toggle-list $ update store :show-list? not
              :speed $ assoc store :speed op-data
    |app.main $ {}
      :ns $ quote
        ns app.main $ :require
          [] respo.core :refer $ [] render! clear-cache! realize-ssr!
          [] app.comp.container :refer $ [] comp-container
          [] app.updater :refer $ [] updater
          [] app.schema :as schema
          [] reel.util :refer $ [] listen-devtools!
          [] reel.core :refer $ [] reel-updater refresh-reel
          [] reel.schema :as reel-schema
          [] cljs.reader :refer $ [] read-string
          [] app.config :as config
          [] cumulo-util.core :refer $ [] repeat!
          "\"./calcit.build-errors" :default build-errors
          "\"bottom-tip" :default hud!
      :defs $ {}
        |render-app! $ quote
          defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
        |persist-storage! $ quote
          defn persist-storage! (? e)
            .setItem js/localStorage (:storage-key config/site)
              format-cirru-edn $ :store @*reel
        |mount-target $ quote
          def mount-target $ .querySelector js/document |.app
        |*reel $ quote
          defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            render-app!
            add-watch *reel :changes $ fn (r p) (render-app!)
            listen-devtools! |a dispatch!
            .addEventListener js/window |beforeunload persist-storage!
            ; repeat! 60 persist-storage!
            let
                raw $ .getItem js/localStorage (:storage-key config/site)
              when (some? raw)
                dispatch! :hydrate-storage $ parse-cirru-edn raw
            println "|App started."
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when config/dev? $ println "\"Dispatch:" op
            reset! *reel $ reel-updater updater @*reel op op-data
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (remove-watch *reel :changes) (clear-cache!)
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              reset! *reel $ refresh-reel @*reel schema/store updater
              hud! "\"ok~" "\"Ok"
            hud! "\"error" build-errors
    |app.page $ {}
      :ns $ quote
        ns app.page
          :require
            [] respo.render.html :refer $ [] make-string
            [] shell-page.core :refer $ [] make-page spit slurp
            [] app.comp.container :refer $ [] comp-container
            [] app.schema :as schema
            [] reel.schema :as reel-schema
            [] cljs.reader :refer $ [] read-string
            [] app.config :as config
            [] cumulo-util.build :refer $ [] get-ip!
          :require-macros $ [] clojure.core.strint :refer ([] <<)
      :defs $ {}
        |base-info $ quote
          def base-info $ {}
            :title $ :title config/site
            :icon $ :icon config/site
            :ssr nil
            :inline-html nil
            :manifest "\"manifest.json"
        |prod-page $ quote
          defn prod-page () $ let
              reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
              html-content $ make-string (comp-container reel)
              assets $ read-string (slurp "\"dist/assets.edn")
              cdn $ if config/cdn? (:cdn-url config/site) "\""
              prefix-cdn $ fn (x) (str cdn x)
            make-page html-content $ merge base-info
              {}
                :styles $ [] (:release-ui config/site)
                :scripts $ map ("#()" -> % :output-name prefix-cdn) assets
                :ssr "\"respo-ssr"
                :inline-styles $ [] (slurp "\"./entry/main.css")
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            if config/dev?
              spit "\"target/index.html" $ dev-page
              spit "\"dist/index.html" $ prod-page
        |dev-page $ quote
          defn dev-page () $ make-page "\""
            merge base-info $ {}
              :styles $ [] (<< "\"http://~{(get-ip!)}:8100/main.css") "\"/entry/main.css"
              :scripts $ [] "\"/client.js"
              :inline-styles $ []
    |app.config $ {}
      :ns $ quote (ns app.config)
      :defs $ {}
        |cdn? $ quote
          def cdn? $ cond
              exists? js/window
              , false
            (exists? js/process) (= "\"true" js/process.env.cdn)
            :else false
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode")
        |site $ quote
          def site $ {} (:dev-ui nil) (:release-ui "\"http://cdn.tiye.me/favored-fonts/main.css") (:cdn-url "\"http://cdn.tiye.me/serial-player/") (:title "\"Serial Player") (:icon "\"http://cdn.tiye.me/logo/termina.png") (:storage-key "\"serial-player")
