#!/usr/bin/env janet

#(def input ``
#123 328  51 64
# 45 64  387 23
#  6 98  215 314
#*   +   *   +
#``)

(def input (string/trim (slurp "inputs/6.txt")))

(def column-counter
  '(* (some (* (number :d+) (any " "))) "\n"))

(def parser
  ~{:operand (number :d+)
    :operands (group (some (* :operand :s*)))
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

################################################################################

(def lines (string/split "\n" input))

(def operator-parser
  ~{:operator (group (* (/ (column) ,dec) (/ (<- (+ "+" "*")) ,eval-string)))
    :main (some (* :operator :s*))})

(def operator-pairs (peg/match operator-parser (array/pop lines)))
(def longest-line-length (max-of (map length lines)))

(var total 0)

(each operator-pair operator-pairs
  (let [index (index-of operator-pair operator-pairs)
        [this-operator-column operator] operator-pair
        next-operator-pair (get operator-pairs (inc index))
        next-operator-column (or (get next-operator-pair 0) longest-line-length)]
    (var stack @[])
    (for column this-operator-column next-operator-column
      (var digits @[])
      (each line lines
        (if-let [_ (< column (length line))
                 character (string/slice line column (inc column))
                 digit (peg/match '(number :d) character)]
          (array/push digits digit)))
      (if (pos? (length digits))
        (do
          (set digits (flatten digits))
          (var operand 0)
	  (var place 1)
          (each digit (reverse digits)
            (+= operand (* digit place))
            (set place (* place 10)))
          (array/push stack operand))))
    (if (> (length stack) 1)
      (+= total (apply operator stack))
      (+= total (first stack)))))

(print "B: " total)
