# Sequence Cursor

A library for moving around a sequence (list/array/tuple) in Janet.

## Usage

1. Add this a dependency in your `project.janet` file.

```clojure
(declare-project
  :name "my-project"
  :description "my project"
  :dependencies ["https://github.com/corasaurus-hex/janet-sequence-cursor"])
```

2. Import the module.

```clojure
(import sequence-cursor :as sc)
```

3. Move forward through a sequence...

```clojure
(def seq (sc/make [:a :b :c]))

(:next? seq)
;;# => true

(:next seq)
;;# => :a

(:next seq)
;;# => :b

(:next seq)
;;# => :c

(:next seq)
;;# error!

(:next? seq)
;;# => false

```

4. Move backward through a sequence...

```clojure
;;# optional starting position, zero-indexed
(def seq (sc/make [:a :b :c] 2))

(:prev? seq)
;;# => true

(:prev seq)
;;# => :b

(:prev seq)
;;# => :a

(:prev seq)
;;# error!

(:prev? seq)
;;# => false
```

5. Get the value at your current position...

```clojure
;;# optional starting position, zero-indexed
(def seq (sc/make [:a :b :c] 2))

(:curr seq)
# => :c

(:prev seq)
;;# => :b
(:curr seq)
;;# => :b

(:curr (sc/make [1 2 3]))
# error!

(:curr? (sc/make [1 2 3]))
# => false

(:curr? seq)
# => true
```

6. Seek around the sequence...

```clojure
(def seq (sc/make [:a :b :c]))

(:seek seq 2) ;;# kind of weird because starting position is really -1
;;# => :b

(:seek seq 1)
;;# => :c

(:seek seq -2)
;;# => :a

(:seek seq -1)
;;# error!

(:seek? seq -1)
;;# => false

(:seek? seq 1)
;;# => true
```

7. Move to an absolute position...

```clojure
(def seq (sc/make [:a :b :c]))

(:move seq 2) # zero-indexed
;;# => :c

(:move seq 0)
;;# => :a

(:move seq 1)
;;# => :b

(:move seq -1)
;;# error!

(:move? seq -1)
;;# => false

(:move? seq 2)
;;# => true
```
