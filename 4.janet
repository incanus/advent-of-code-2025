#!/usr/bin/env janet

(def input ``
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
``)

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

(pp rows)
