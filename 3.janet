#!/usr/bin/env janet

(def input 
  "987654321111111
   811111111111119
   234234234234278
   818181911112111")

(def grammar
  '{:battery (number :d)
    :bank (some :battery)
    :main (some (* (group :bank) :s*))})

(each bank (peg/match grammar input)
  (var ranks @[])
  (for i 0 (length bank)
    (array/push ranks [(bank i) i]))
  (var a '(0 math/int32-max))
  (var b '(0 math/int32-max))
  (each rank ranks
    (if (> (rank 0) (a 0)) 
      (set a rank)))
  (each rank ranks
    (if
      (and
        (> (rank 0) (b 0))
        (> (rank 1) (a 1)))
      (set b rank)))
  (print (a 0) " " (b 0)))