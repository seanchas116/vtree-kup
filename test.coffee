test = require 'tape'
vtreeKup = require './index'
VNode = require 'vtree/vnode'
VText = require 'vtree/vtext'

test 'generate node', (t) ->
  t.equal new VNode 'div', vtreeKup (k) -> k.div

test 'generate node with properties', (t) ->
  t.equal new VNode('div', {style: {display: 'none'}}), vtreeKup (k) -> k.div style: {display: 'none'}

test 'generate node with class/id', (t) ->
  t.equal new VNode('div', {class: 'hoge piyo', id: 'foo'}, [new VText('text')]),
    vtreeKup (k) ->
      k.div '.hoge.piyo#foo', 'text'

test 'generate node with cildren', (t) ->
  expected = new VNode 'div', {class: 'root', style: {width: '100px'} }, [
    new VNode 'p', {}, [new VText 'hoge']
    new VNode 'button', {id: 'button1'}, [new VText 'click me']
  ]
  actual = vtreeKup (k) ->
    k.div '.root', style: {width: '100px'}, ->
      k.p 'hoge'
      k.button '#button1', 'click me'
  t.deepEqual expected, actual
