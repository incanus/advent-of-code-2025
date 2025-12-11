#!/usr/bin/env janet

#(def input ``
#aaa: you hhh
#you: bbb ccc
#bbb: ddd eee
#ccc: ddd eee fff
#ddd: ggg
#eee: out
#fff: out
#ggg: out
#hhh: ccc fff iii
#iii: out
#``)

(def input (slurp "inputs/11.txt"))

(def grammar
  '{:device (3 :a)
    :outputs (group (some (* (<- :device) (any " "))))
    :line (* (<- :device) ": " :outputs (any "\n"))
    :main (some :line)})

(def devices (table ;(peg/match grammar input)))

(var total 0)

(defn follow [device-name]
  (if (= (get (devices device-name) 0) "out")
    (++ total)
    (each other-device-name (devices device-name)
      (follow other-device-name))))

(follow "you")

(print "A: " total)
