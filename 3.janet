#!/usr/bin/env janet

(def input "987654321111111 811111111111119 234234234234278 818181911112111")

# (def input (slurp "inputs/3.txt"))

(def grammar
  '{:battery (number :d)
    :bank (some :battery)
    :main (some (* (group :bank) :s*))})

(def banks (peg/match grammar input))

(defn solve [bank &opt a b]
  (if (or (nil? a) (nil? b))
    (let [max (max-of bank)
          pos (index-of max bank)
          lst (dec (length bank))]
      (if (= pos lst)
        (do
          (array/pop bank)
          (if (and (nil? a) (nil? b))
            (solve bank a max)
            (solve bank max b)))
        (let [bank (slice bank (inc pos))]
          (if (nil? a)
            (solve bank max b)
            (solve bank a max)))))
    (do
      (scan-number (string a b)))))

(print (apply + (map |(solve $) banks)))
