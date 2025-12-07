#!/usr/bin/env janet

#(def input ``
#123 328  51 64
# 45 64  387 23
#  6 98  215 314
#*   +   *   +
#``)

 (def input (slurp "inputs/6.txt"))

(def column-counter
  '(* (some (* (number :d+) (any " "))) "\n"))

(def parser
  ~{:operand :d+
    :operands (group (some (* (number :operand) :s*)))
    :operator (/ (<- (+ "+" "*")) ,eval-string)
    :operators (group (some (* :operator :s*)))
    :main (* :operands :operators)})

(def column-count (length (peg/match column-counter input)))
(def [operands operators] (peg/match parser input))

(var total 0)

(each column (range column-count)
  (var stack @[])
  (var index 0)
  (while
    (if-let [operand (get operands (+ column index))]
      (do
        (array/push stack operand)
        (+= index column-count))))
  (+= total (apply (operators column) stack)))

(print "A: " total)
