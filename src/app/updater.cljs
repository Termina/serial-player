
(ns app.updater (:require [respo.cursor :refer [mutate]]))

(defn updater [store op op-data op-id op-time]
  (case op
    :states (update store :states (mutate op-data))
    :hydrate-storage op-data
    :change-index (assoc store :playing-idx op-data)
    :inc-index (update store :playing-idx inc)
    :dec-index (update store :playing-idx dec)
    :toggle-control (update store :show-control? not)
    :toggle-list (update store :show-list? not)
    :speed (assoc store :speed op-data)
    store))
