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
  ~{:roll (+ (* (/ (column) ,|(- $ 1)) "@") (drop "."))
    :row (group (* (some :roll) (drop :s*)))
    :main (some :row)})

(def rows (peg/match grammar input))

#(pp rows)

(var total 0)

(let [last-row (- (length rows) 1)]
  (for r 0 (length rows)
    (let [row (rows r)]
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
          (++ total))))))

(print "A: " total)
