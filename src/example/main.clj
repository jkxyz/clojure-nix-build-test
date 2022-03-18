(ns example.main
  (:gen-class))

(defn -main [& args]
  (println "Hello, World!")
  (println "Java version:" (System/getProperty "java.version")))
