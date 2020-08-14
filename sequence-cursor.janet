#!/usr/bin/env janet
#
# A cursor that moves back and forth through a sequence type (Tuple/Array/List).
# It will yield nil forever when it runs out of values.
#

(defn next?
  [cursor]
  (< (cursor :position) (cursor :max-position)))

(defn next
  [cursor]
  (when (not (:next? cursor))
    (error "sequence-cursor: no next element"))
  (:seek cursor +1)
  (:curr cursor))

(defn prev?
  [cursor]
  (:seek? cursor -1))

(defn prev
  [cursor]
  (when (not (:prev? cursor))
    (error "sequence-cursor: no previous element"))
  (:seek cursor -1)
  (:curr cursor))

(defn curr
  [cursor]
  (when (< (cursor :position) 0)
    (error "sequence-cursor: no current element"))
  (get-in cursor [:iterable (cursor :position)]))

(defn curr?
  [cursor]
  (not= (cursor :position) -1))

(defn seek
  [cursor offset]
  (when (not (:seek? cursor offset))
    (errorf "sequence-cursor: unable to seek %d" offset))
  (:move cursor (+ offset (cursor :position))))

(defn seek?
  [cursor offset]
  (:move? cursor (+ offset (cursor :position))))

(defn move
  [cursor position]
  (when (not (:move? cursor position))
    (errorf "sequence-cursor: cannot move to %d" position))
  (put cursor :position position)
  (:curr cursor))

(defn move?
  [cursor position]
  (<=
    0
    position
    (cursor :max-position)))

(def Cursor
  @{:iterable nil
    :position -1
    :max-position nil
    :next next
    :next? next?
    :prev prev
    :prev? prev?
    :curr curr
    :curr? curr?
    :seek seek
    :seek? seek?
    :move move
    :move? move?})

(defn make
  "Makes a cursor."
  [iterable &opt position]
  (table/setproto
    @{:iterable iterable
      :position position
      :max-position (dec (length iterable))}
    Cursor))
