#!/usr/bin/env janet

# (var input '(L68 L30 R48 L5 R60 L55 L1 L99 R14 L82))

(var input (string/split "\n" (string/trim (slurp "inputs/1.txt"))))

(set input (map 
             (fn [n]
               (if (string/has-prefix? "L" n)
                 (- (scan-number (string/triml n "L")))
                 (scan-number (string/triml n "R"))))
             input))

(var place 50)
(var count 0)

(print)
(loop [x :in input]
  (prin place " + " x " = ")
  (set place (% (+ place x) 100))
  (prin place)
  (if (neg? place)
    (do
      (+= place 100)
      (prin " -> " place)))
  (print)
  (if (zero? place) (++ count)))

(print "\nPassword A: " count "\n")
