
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/
      :type-slots $ {} $ :dispatch-op 'app.schema/Action
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (idx speed controls show-list?)
            div
              {} $ :style $ merge ui/global ui/fullscreen ui/center
                {} (:background-color :black) (:user-select :none)
              create-element :video $ {}
                :src $ str |videos/ $ .unwrap-or (nth data/videos idx) |
                :playback-rate speed
                :autoplay true
                :controls controls
                :style $ {} (:max-width |100%) (:max-height |100%) (:outline :none)
              comp-header idx speed
              if show-list? (comp-list idx) (div {})
          :examples $ []
          :schema $ quote $ Fn Number Number Bool Bool (-> respo.schema/Component)
        'comp-header $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-header (idx speed)
            div
              {} $ :style $ merge ui/row-parted
                {} (:position :fixed) (:bottom 0) (:left 0) (:height 64) (:width |100%) (:background-color "|rgba(0,0,0,0.8)") (:border-top "|1px solid rgba(255,255,255,0.4)") (:padding "|0 20px") (:z-index 100)
              div
                {} $ :style $ merge ui/row-middle
                  {} $ :padding "|0 16px"
                button $ {} (:inner-text |Prev) (:style ui/button)
                  :on-click $ fn (e d!)
                    d! $ schema/Action :dec-index
                =< 8 nil
                button $ {} (:inner-text |Next) (:style ui/button)
                  :on-click $ fn (e d!)
                    d! $ schema/Action :inc-index
                =< 8 nil
                <> $ str "|Video " (inc idx) "| / " $ count data/videos
              div
                {} $ :style ui/row-middle
                comp-speed 1 $ = speed 1
                comp-speed 1.4 $ = speed 1.4
                comp-speed 2 $ = speed 2
                =< 16 nil
                button $ {} (:inner-text |List) (:style ui/button)
                  :on-click $ fn (e d!)
                    d! $ schema/Action :toggle-list
          :examples $ []
          :schema $ quote $ Fn Number Number (-> respo.schema/Component)
        'comp-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-list (idx)
            div
              {} $ :style $ merge ui/fullscreen ui/center
                {} (:z-index 1000) (:background-color "|rgba(0,0,0,0.6)")
              div
                {} $ :style $ merge ui/column
                  {} (:width 600) (:height 400) (:background-color "|rgba(0,0,0,0.8)") (:color :white)
                list->
                  {} $ :style $ merge ui/expand
                    {} (:padding "|16px 0") (:overflow :auto)
                  map-indexed data/videos $ fn (i name)
                    [] name $ div $ {} (:inner-text name)
                      :style $ merge
                        {} (:padding "|0 16px") (:font-size 20) (:line-height |40px) (:cursor :pointer)
                        if (= i idx)
                          {} $ :background-color "|rgba(255,255,255,0.2)"
                          {}
                      :on-click $ fn (e d!)
                        d! $ schema/Action :set-index i
          :examples $ []
          :schema $ quote $ Fn Number (-> respo.schema/Component)
        'comp-speed $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-speed (speed selected?)
            span $ {}
              :inner-text $ str |x speed
              :style $ merge $ {}
                :color $ if selected? |white |#aaa
                :font-size 14
                :font-family ui/font-code
                :margin "|0 12px"
                :cursor :pointer
              :on-click $ fn (e d!)
                d! $ schema/Action :set-speed speed
          :examples $ []
          :schema $ quote $ Fn Number Bool (-> respo.schema/Component)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp div span button <> list-> create-element
            respo.comp.space :refer $ =<
            app.schema :as schema
            app.data :as data
    'app.data $ %{} 'FileEntry
      :defs $ {} $ 'videos
        %{} 'CodeEntry (:doc |)
          :code $ quote $ def videos
            [] |SAO/01.mp4 |SAO/02.mp4 |SAO/03.mp4 |SAO/04.mp4 |SAO/05.mp4 |SAO/06.mp4 |SAO/07.mp4 |SAO/08.mp4 |SAO/09.mp4 |SAO/10.mp4 |SAO/11.mp4 |SAO/12.mp4 |SAO/13.mp4 |SAO/14.mp4 |SAO/15.mp4 |SAO/16.mp4 |SAO/17.mp4 |SAO/18.mp4 |SAO/19.mp4 |SAO/20.mp4 |SAO/21.mp4 |SAO/22.mp4 |SAO/23.mp4 |SAO/24.mp4 |SAO/25.mp4 |SAO2/01.mp4 |SAO2/02.mp4 |SAO2/03.mp4 |SAO2/04.mp4 |SAO2/05.mp4 |SAO2/06.mp4 |SAO2/07.mp4 |SAO2/08.mp4 |SAO2/09.mp4 |SAO2/10.mp4 |SAO2/11.mp4 |SAO2/12.mp4 |SAO2/13.mp4 |SAO2/14.mp4 |SAO2/15.mp4 |SAO2/16.mp4 |SAO2/17.mp4 |SAO2/18.mp4 |SAO2/19.mp4 |SAO2/20.mp4 |SAO2/21.mp4 |SAO2/22.mp4 |SAO2/23.mp4 |SAO2/24.mp4
          :examples $ []
          :schema $ quote $ List String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.data
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*controls $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *controls true
          :examples $ []
          :schema $ quote $ Ref Bool
        '*idx $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *idx 0
          :examples $ []
          :schema $ quote $ Ref Number
        '*show-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *show-list false
          :examples $ []
          :schema $ quote $ Ref Bool
        '*speed $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *speed 1
          :examples $ []
          :schema $ quote $ Ref Number
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (action)
            match action
              (:set-speed value) (reset! *speed value)
              (:set-index value)
                reset! *idx $ if (< value 0) 0 $ if
                  > value $ dec $ count data/videos
                  dec $ count data/videos
                  , value
              (:inc-index)
                reset! *idx $ if
                  < @*idx $ dec $ count data/videos
                  inc @*idx
                  , @*idx
              (:dec-index)
                reset! *idx $ if (> @*idx 0) (dec @*idx) 0
              (:toggle-list)
                reset! *show-list $ not @*show-list
              (:toggle-control)
                reset! *controls $ not @*controls
            , &unit
          :examples $ []
          :schema $ quote $ Fn schema/Action (-> Unit) (:features :state)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (println "|Serial Player started.") (render-app!)
            add-watch! *idx :changes $ fn (s p) (render-app!)
            add-watch! *speed :changes $ fn (s p) (render-app!)
            add-watch! *controls :changes $ fn (s p) (render-app!)
            add-watch! *show-list :changes $ fn (s p) (render-app!)
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ query-selector |.app
          :examples $ []
          :schema $ quote respo.dom/DomElement
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch! *idx :changes) (remove-watch! *speed :changes) (remove-watch! *controls :changes) (remove-watch! *show-list :changes) (render-app!)
                add-watch! *idx :changes $ fn (s p) (render-app!)
                add-watch! *speed :changes $ fn (s p) (render-app!)
                add-watch! *controls :changes $ fn (s p) (render-app!)
                add-watch! *show-list :changes $ fn (s p) (render-app!)
              , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*idx @*speed @*controls @*show-list
              , dispatch!
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with!
            respo.ffi.browser :refer $ query-selector
            app.comp.container :refer $ comp-container
            app.schema :as schema
            app.data :as data
            |./calcit.build-errors :default build-errors
    'app.schema $ %{} 'FileEntry
      :defs $ {} $ 'Action
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Action (:set-speed Number) (:set-index Number) (:inc-index) (:dec-index) (:toggle-list) (:toggle-control)
          :examples $ []
          :schema $ quote EnumDef
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
