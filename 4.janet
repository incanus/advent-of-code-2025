#!/usr/bin/env janet

#(def input ``
#..@@.@@@@.
#@@@.@.@.@@
#@@@@@.@.@@
#@.@@@@..@.
#@@.@@@@.@@
#.@@@@@@@.@
#.@.@.@.@@@
#@.@@@.@@@@
#.@@@@@@@@.
#@.@.@@@.@.
#``)

(def input (slurp "inputs/4.txt"))

(def directions
  [ [-1 -1]    # nw
    [ 0 -1]    # n
    [ 1 -1]    # ne
    [-1  0]    # w
    [ 1  0]    # e
    [-1  1]    # sw
    [ 0  1]    # s
    [ 1  1] ]) # se

(def grammar
  ~{:roll (+ (* (/ (column) ,|(dec $)) "@") (drop "."))
    :row (group (* (some :roll) (drop :s*)))
    :main (some :row)})

(def rows (peg/match grammar input))

(defn count-rolls [&opt remove]
  (var total 0)
  (var row nil)
  (let [last-row (dec (length rows))]
    (for r 0 (length rows)
      (with-vars [row (rows r)]
        (each roll row
          (var neighbors 0)
          (each direction directions
            (let [x (direction 0)
                  y (direction 1)
                  check-row (+ r y)
                  check-col (+ roll x)]
              (if (and (>= check-row 0)
                       (<= check-row last-row))
                (if (index-of check-col (get rows check-row))
                  (do
                    (++ neighbors))))))
          (if (< neighbors 4)
            (do
              (if remove
                (do
                  (set row (filter |(not= $ roll) row))
                  (put rows r row)))
              (++ total)))))))
  total)

(print "A: " (count-rolls))
