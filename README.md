vtree-kup
=========

[![npm version](https://badge.fury.io/js/vtree-kup.svg)](http://badge.fury.io/js/vtree-kup)
[![Build Status](https://travis-ci.org/seanchas116/vtree-kup.svg)](https://travis-ci.org/seanchas116/vtree-kup)

vtree-kup provides [CoffeeKup](https://github.com/mauricemach/coffeekup)-like DSL for building [virtual-dom](https://github.com/Matt-Esch/virtual-dom) tree.

Installation
---------

    $ npm install vtree-kup

Usage
---------

### Basic

```coffeescript
vtreeKup = require 'vtree-kup'

render = (counter) -> vtreeKup (k) ->
  k.h1 'Counter'
  k.p counter.value
  k.button { onclick: -> counter.increment() }, 'Increment'
```

### Selectors

A string is used to specify classes and an id for the element
if it is the first argument and valid as a selector.

```coffeescript
k.h1 '.title#counter-title', 'Counter'
```

### Inline elements

```coffeescript
k.div 'This is an', (-> k.span '.is-important' 'important'), 'element'
```

### Insert virtual-dom nodes

```coffeescript
k.h1 'Counter'
# #$add accepts both an array and a node
k.$add new VNode('p', {}, [new VText(String(counter.value))])
k.button { onclick: -> counter.increment() }, 'Increment'
```

Todo
---------

* Add new tags (for custom elements)
* Namespace support (SVG, MathML)
* Browser tests
