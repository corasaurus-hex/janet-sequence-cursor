# Sequence Cursor

A library for moving around a sequence (list/array/tuple) in Janet.

## Usage

1. Add this a dependency in your `project.janet` file and install deps.

```clojure
(declare-project
  :name "my-project"
  :description "my project"
  :dependencies ["https://github.com/corasaurus-hex/janet-sequence-cursor"])
```

```sh
jpm deps
```

2. Import the module.

```clojure
(import sequence-cursor :as sc)
```

3. Use!

```clojure
(def seq (sc/make [:a :b :c]))

(:next seq)
;;# => :a
```

## Documentation

Check out the tests and the docs on individual functions for more on how to use this.
