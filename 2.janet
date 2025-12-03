#!/usr/bin/env janet

(def input "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124")

(def grammar
  '{:id (number (at-least 2 :d))
    :invalid-id (number (repeat 2 (some :d)))
    :range (* :invalid-id "-" :invalid-id)
    :main (* (some (* :range (opt ","))))})
    #:range (* (+ :invalid-id :id) "-" (+ :invalid-id :id))


(pp (peg/match grammar input))
