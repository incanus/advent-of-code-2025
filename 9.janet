#!/usr/bin/env janet

(def input ``
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
``)

(def grammar
  '{:coordinate (* (number :d+) "," (number :d+))
    :line (* (group (some :coordinate)) :s*)
    :main (* (some :line))})

(def tiles (peg/match grammar input))

(defn visualize [tiles &opt corners]
  (let [width  (+ 3 (max-of (map |(get $ 0) tiles)))
        height (+ 2 (max-of (map |(get $ 1) tiles)))]
    (for y 0 height
      (for x 0 width
        (if (and corners
                 (<= ((corners 0) 0) x)
                 (<= ((corners 0) 1) y)
                 (>= ((corners 1) 0) x)
                 (>= ((corners 1) 1) y))
          (prin "O")
          (if (find |(and (= x ($ 0)) (= y ($ 1))) tiles)
            (prin "#")
            (prin "."))))
      (print)))
  (if corners
    (print "area: "
        (* (inc (math/abs (- ((corners 0) 0) ((corners 1) 0))))
           (inc (math/abs (- ((corners 0) 1) ((corners 1) 1))))))
    (print "(no corners)"))
  (print))

(visualize tiles)
(visualize tiles [ [2 5] [9 7] ])
(visualize tiles [ [7 1] [11 7] ])