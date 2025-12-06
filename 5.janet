#!/usr/bin/env janet

#(def input ``
#3-5
#10-14
#16-20
#12-18
#
#1
#5
#8
#11
#17
#32
#``)

(def input (slurp "inputs/5.txt"))

(def grammar
  '{:range (group (* (number :d+) "-" (number :d+) :s))
    :ingredient (* (number :d+) :s*)
    :main (* (some :range) :s+ (group (some :ingredient)))})

(defn finder [ingredient range]
  (and (>= ingredient (range 0))
       (<= ingredient (range 1))))

(var fresh 0)

(let [ranges (peg/match grammar input)
      ingredients (array/pop ranges)]
  (each i ingredients
    (label ingredient
      (each r ranges
        (if (finder i r)
          (do
            (++ fresh)
            (return ingredient)))))))

(print "A: " fresh)
