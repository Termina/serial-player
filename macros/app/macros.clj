
(ns app.macros)

(defmacro video [props & children]
  `(respo.core/create-element :video ~props ~@children))
