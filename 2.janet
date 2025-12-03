#!/usr/bin/env janet

# (def input "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124")

(def input (slurp "inputs/2.txt"))

(def range-grammar
  '{:id (number (some :d))
    :range (* :id "-" :id)
    :main (* (some (* (group :range) (opt ","))))})

(def ranges (peg/match range-grammar input))

(var sum 0)

(loop [range :in ranges]
  (for i (first range) (+ (last range) 1)
    (let [str (string i)
          len (/ (length str) 2)]
      (if (and (int? len) (= (slice str 0 len) (slice str len)))
        (+= sum i)))))

(print "Sum A: " sum)
