'use strict'

VNode = require 'vtree/vnode'
VText = require 'vtree/vtext'
extend = require 'xtend/mutable'

tags = '
  html head title base link meta style script noscript template body body
  section nav article aside h1 h2 h3 h4 h5 h6 header footer
  address main p hr pre blockquote ol ul li dl dt dd dd figure figcaption div a
  em strong small s cite q dfn abbr itl data time atetim code var samp kbd sub
  sup i b u mark ruby rt rp bdi bdo span las an i br wbr ins del img iframe
  embed object param object video audio source video audio track video audio
  canvas map area area map svg  table caption colgroup col tbody thead tfoot tr
  td th form fieldset legend fieldset label input button select datalist
  optgroup option select datalist textarea keygen output progress meter details
  summary details menuitem menu'.split(/\s+/)

parseSelector = (selector) ->
  classes = []
  id = null

  splits = selector.split(/([.#])/)

  # does not start with /[.#]/
  if splits[0].length > 0
    return null

  i = 1
  while i < splits.length
    switch splits[i]
      when '.'
        classes.push splits[i + 1]
      when '#'
        id = splits[i + 1]
    i += 2

  result = {}
  if classes.length > 0
    result.class = classes.join(' ')
  if id?
    result.id = id
  result

class VTreeKup
  constructor: (@namespace) ->
    @nodesStack = [[]]
    @nodes = []

  topNodes: ->
    @nodesStack[@nodesStack.length - 1]

  $vtree: (tree) ->
    @topNodes().push tree

  $tag: (name, args...) ->
    children = []
    properties = {}
    text = null
    topNodes = @topNodes()

    for arg, i in args
      switch typeof arg
        when 'function'
          @nodesStack.push []
          arg()
          children.push @nodesStack.pop()...
        when 'object'
          extend properties, arg
        when 'number', 'boolean'
          children.push new VText(String(arg))
        when 'string'
          if args.length != 1 && i == 0 && (classId = parseSelector(arg))?
            extend properties, classId
          else
            children.push new VText(arg)

    topNodes.push new VNode(name, properties, children, null, @namespace)

  @addTag: (tag) ->
    @::[tag] = (args...) -> @$tag(tag, args...)

for tag in tags
  VTreeKup.addTag tag

vtreeKup = (block) ->
  k = new VTreeKup(null)
  block(k)
  nodes = k.topNodes()
  #if nodes.length >= 2
  #  throw new Error('cannot create multiple root nodes')
  nodes[0]

vtreeKup.addTag = (tag) ->
  VTreeKup.addTag tag

module.exports = vtreeKup
