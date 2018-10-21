
(ns app.config (:require [app.util :refer [get-env!]]))

(def bundle-builds #{"release" "local-bundle"})

(def dev?
  (if (exists? js/window)
    (do ^boolean js/goog.DEBUG)
    (not (contains? bundle-builds (get-env! "mode")))))

(def site
  {:storage "serial-player",
   :dev-ui nil,
   :release-ui "http://cdn.tiye.me/favored-fonts/main.css",
   :cdn-url "http://cdn.tiye.me/serial-player/",
   :cdn-folder "tiye.me:cdn/serial-player",
   :title "Serial Player",
   :icon "http://cdn.tiye.me/logo/mvc-works.png",
   :upload-folder "tiye.me:repo/Memkits/serial-player/"})
