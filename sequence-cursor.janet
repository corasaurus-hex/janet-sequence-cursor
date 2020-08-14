#!/usr/bin/env janet
#
# A cursor that moves back and forth through a sequence type (Tuple/Array/List).
# It will yield nil forever when it runs out of values.
#

(defn next?
  `Determines if there is a next element to move the cursor to.

  Example

  (:next? (make [1 2 3]))
  # => true
  (:next? (make [1 2 3] 2))
  # => false`
  [cursor]
  (< (cursor :position) (cursor :max-position)))

(defn next
  `Moves the cursor to the next position and returns the element the
  cursor has moved to.

  Raises an error if there is no next position.

  Example

  (def sc (make [1 2]))
  (:next seq)
  # => 1
  (:next seq)
  # => 2
  (:next seq)
  # error "sequence-cursor: no next element"`
  [cursor]
  (when (not (:next? cursor))
    (error "sequence-cursor: no next element"))
  (:seek cursor +1)
  (:curr cursor))

(defn prev?
  `Determines if there is a previous element to move the cursor to.

  Example

  (:prev? (make [1 2 3]))
  # => false
  (:prev? (make [1 2 3] 2))
  # => true`
  [cursor]
  (:seek? cursor -1))

(defn prev
  `Moves the cursor to the previous position and returns the element the
  cursor has moved to.

  Raises an error if there is no previous position.

  Example

  (def sc (make [1 2 3] 2))
  (:prev seq)
  # => 2
  (:prev seq)
  # => 1
  (:prev seq)
  # error "sequence-cursor: no previous element"`
  [cursor]
  (when (not (:prev? cursor))
    (error "sequence-cursor: no previous element"))
  (:seek cursor -1)
  (:curr cursor))

(defn curr?
  `Determines if there is a current element the cursor is positioned at.

  Example

  (:curr? (make [1 2 3]))
  # => false
  (:curr (make [1 2 3] 1))
  # => true`
  [cursor]
  (not= (cursor :position) -1))

(defn curr
  `Returns the element the cursor currently is positioned at.

  Raises an error if there is no current element.

  Example

  (:curr (make [1 2 3]))
  # error "sequence-cursor: no current element"
  (:curr (make [1 2 3] 1))
  # => 2`
  [cursor]
  (when (< (cursor :position) 0)
    (error "sequence-cursor: no current element"))
  (get-in cursor [:sequence (cursor :position)]))

(defn seek?
  `Determines if the cursor can seek to an offset.

  Example

  (def sc (make [1 2 3] 1))
  (:seek? sc 1)
  # => true
  (:seek? sc -1)
  # => true
  (:seek? sc 10)
  # => false`
  [cursor offset]
  (:move? cursor (+ offset (cursor :position))))

(defn seek
  `Moves the cursor by a count of offset. Positive numbers move
  nextward, negative prevward.

  Raises an error if the offset is not seekable.

  Example

  (def sc (make [:a :b :c]))
  (:seek sc 2)
  # => :b
  (:seek sc -1)
  # => :a
  (:seek sc 10)
  # error "sequence-cursor: unable to seek 10"`
  [cursor offset]
  (when (not (:seek? cursor offset))
    (errorf "sequence-cursor: unable to seek %d" offset))
  (:move cursor (+ offset (cursor :position))))

(defn move?
  `Determines if the cursor can move to a position.

  Example

  (def sc (make [1 2 3]))
  (:move? sc 0)
  # => true
  (:move? sc 2)
  # => true
  (:move? sc 10)
  # => false`
  [cursor position]
  (<=
    0
    position
    (cursor :max-position)))

(defn move
  `Moves the cursor to an absolute position, zero-indexed.

  Raises an error if the position cannot be moved to.

  Example

  (def sc (make [:a :b :c]))
  (:move sc 2)
  # => :c
  (:move sc 1)
  # => :a
  (:move sc 10)
  # error "sequence-cursor: cannot move to 10"`
  [cursor position]
  (when (not (:move? cursor position))
    (errorf "sequence-cursor: cannot move to %d" position))
  (put cursor :position position)
  (:curr cursor))

(def Cursor
  @{:sequence nil
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
  `Makes a sequence cursor using the passed-in sequence. An optional
  position can be used as a starting point, zero-indexed. The default
  starting position is -1, meaning your first call of :next will return
  the first item in the sequence.

  Example

  (:next (make [:a :b :c]))
  # => :a
  (:next (make [:a :b :c] 0))
  # => :b`
  [sequence &opt position]
  (table/setproto
    @{:sequence sequence
      :position position
      :max-position (dec (length sequence))}
    Cursor))
