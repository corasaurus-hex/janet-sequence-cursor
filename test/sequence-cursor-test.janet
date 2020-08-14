#!/usr/bin/env janet

(import tester :prefix "")
(import sequence-cursor :as sc)

(defn cursor
  [&opt pos]
  (sc/make
    [:a :b :c]
    (or pos -1)))

(defmacro assert-error
  [message & body]
  ~(try
     (do
       ,;body
       false)
     ([err]
      (= ,message err))))

(deftest "squabble/sequence-cursor"
  (test ":next gets the next element"
    (let [cursor (cursor)]
      (and
        (= :a (:next cursor))
        (= :b (:next cursor))
        (= :c (:next cursor)))))
  (test ":next raises an error when the list is exhausted"
    (assert-error "sequence-cursor: no next element" (:next (cursor 2))))
  (test ":next? returns true when there are next elements"
    (and
      (:next? (cursor))
      (:next? (cursor 1))))
  (test ":next? returns false when there are no next elements"
    (false? (:next? (cursor 2))))
  (test ":prev gets the previous element"
    (let [cursor (cursor 2)]
      (and
        (= :b (:prev cursor))
        (= :a (:prev cursor)))))
  (test ":prev raises an error when the list is exhausted"
    (and
      (assert-error "sequence-cursor: no previous element" (:prev (cursor)))
      (assert-error "sequence-cursor: no previous element" (:prev (cursor 0)))))
  (test ":prev? returns true when there are previous elements"
    (and
      (:prev? (cursor 2))
      (:prev? (cursor 1))))
  (test ":prev? returns false when there are no next elements"
    (and
      (false? (:prev? (cursor)))
      (false? (:prev? (cursor 0)))))
  (test ":curr raises an error when the cursor has not been moved into the list"
    (assert-error "sequence-cursor: no current element" (:curr (cursor))))
  (test ":curr returns the element at the current position when there is one"
    (let [cursor (cursor)]
      (and
        (= :a (:next cursor))
        (= :a (:curr cursor))
        (= :b (:next cursor))
        (= :b (:curr cursor))
        (= :c (:next cursor))
        (= :c (:curr cursor)))))
  (test ":seek changes the position by an offset"
    (let [cursor (cursor)]
      (and
        (= :b (:seek cursor +2))
        (= :a (:seek cursor -1))
        (= :c (:seek cursor +2)))))
  (test ":seek raises an error when the cursor cannot seek to that offset"
    (and
      (assert-error "sequence-cursor: unable to seek 5" (:seek (cursor) +5))
      (assert-error "sequence-cursor: unable to seek -2" (:seek (cursor) -2))))
  (test ":seek? returns true when the offset is seekable"
    (and
      (:seek? (cursor) +1)
      (:seek? (cursor 2) -2)
      (:seek? (cursor 1) +1)))
  (test ":seek? returns false when the offset is not seekable"
    (and
      (false? (:seek? (cursor) +10))
      (false? (:seek? (cursor 2) -3))))
  (test ":move changes to an absolute position"
    (let [cursor (cursor)]
      (and
        (= :a (:move cursor 0))
        (= :c (:move cursor 2))
        (= :b (:move cursor 1)))))
  (test ":move raises an error when the cursor cannot be moved to that position"
    (and
      (assert-error "sequence-cursor: cannot move to 5" (:move (cursor) 5))
      (assert-error "sequence-cursor: cannot move to -2" (:move (cursor) -2))))
  (test ":move? returns true when the cursor can be moved to that position"
    (and
      (:move? (cursor) 0)
      (:move? (cursor) 1)
      (:move? (cursor) 2)))
  (test ":move? returns false when the cursor cannot be moved to that position"
    (and
      (false? (:move? (cursor) -5))
      (false? (:move? (cursor) 10))))
  )
