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
  (test ":next? returns true when there are next elements"
    (and
      (:next? (cursor))
      (:next? (cursor 1))))
  (test ":next? returns false when there are no next elements"
    (false? (:next? (cursor 2))))
  (test ":next gets the next element"
    (let [cursor (cursor)]
      (and
        (= :a (:next cursor))
        (= :b (:next cursor))
        (= :c (:next cursor)))))
  (test ":next raises an error when the list is exhausted"
    (assert-error "sequence-cursor: no next element" (:next (cursor 2))))
  (test ":prev? returns true when there are previous elements"
    (and
      (:prev? (cursor 2))
      (:prev? (cursor 1))))
  (test ":prev? returns false when there are no next elements"
    (and
      (false? (:prev? (cursor)))
      (false? (:prev? (cursor 0)))))
  (test ":prev gets the previous element"
    (let [cursor (cursor 2)]
      (and
        (= :b (:prev cursor))
        (= :a (:prev cursor)))))
  (test ":prev raises an error when the list is exhausted"
    (and
      (assert-error "sequence-cursor: no previous element" (:prev (cursor)))
      (assert-error "sequence-cursor: no previous element" (:prev (cursor 0)))))
  (test ":curr? returns true when there is an element at the current position"
    (:curr? (cursor 0)))
  (test ":curr? returns false when there is no element at the current position"
    (false? (:curr? (cursor))))
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
  (test ":seek? returns true when the offset is seekable"
    (and
      (:seek? (cursor) +1)
      (:seek? (cursor 2) -2)
      (:seek? (cursor 1) +1)))
  (test ":seek? returns false when the offset is not seekable"
    (and
      (false? (:seek? (cursor) +10))
      (false? (:seek? (cursor 2) -3))))
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
  (test ":move? returns true when the cursor can be moved to that position"
    (and
      (:move? (cursor) 0)
      (:move? (cursor) 1)
      (:move? (cursor) 2)))
  (test ":move? returns false when the cursor cannot be moved to that position"
    (and
      (false? (:move? (cursor) -5))
      (false? (:move? (cursor) 10))))
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
  (test ":peek? returns true when when there is an element at the given offset from the cursor position"
    (and
      (:peek? (cursor) 1)
      (:peek? (cursor 2) -1)))
  (test ":peek? returns false when there is no element at the given offset from the cursor position"
    (and
      (false? (:peek? (cursor) 10))
      (false? (:peek? (cursor 2) -10))))
  (test ":peek returns the element at the given offset from the cursor position without changing the cursor position"
    (let [cursor (cursor 1)]
      (and
        (= :c (:peek cursor 1))
        (= :a (:peek cursor -1))
        (= :b (:curr cursor)))))
  (test ":peek raises an error when there is no element at the given offset from the cursor position"
    (and
      (assert-error "sequence-cursor: unable to peek 10" (:peek (cursor 1) 10))
      (assert-error "sequence-cursor: unable to peek -10" (:peek (cursor 1) -10))))
  (test ":get? returns true when there is an element at the absolute position"
    (and
      (:get? (cursor) 0)
      (:get? (cursor) 2)))
  (test ":get? returns false when there is no element at the absolute position"
    (and
      (false? (:get? (cursor) -1))
      (false? (:get? (cursor) 3))))
  (test ":get returns the element at the absolute position"
    (and
      (= :a (:get (cursor) 0))
      (= :c (:get (cursor) 2))))
  (test ":get raises an error when there is no element at the absolute position"
    (and
      (assert-error "sequence-cursor: cannot get -1" (:get (cursor) -1))
      (assert-error "sequence-cursor: cannot get 10" (:get (cursor) 10))))
  )
