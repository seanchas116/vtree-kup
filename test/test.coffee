assert = (require 'chai').assert
vtreeKup = require '../lib/index'
VNode = require 'virtual-dom/vnode/vnode'
VText = require 'virtual-dom/vnode/vtext'

describe 'VTreeKup', ->

  it 'generates node', ->
    actual = vtreeKup (k) ->
      k.div()
    assert.deepEqual actual, new VNode('div')

  it 'generates node with properties', ->
    actual = vtreeKup (k) ->
      k.div style: {display: 'none'}
    assert.deepEqual actual, new VNode('div', {style: {display: 'none'}})

  it 'generates node with class/id', ->
    actual = vtreeKup (k) ->
      k.div '.hoge.piyo#foo', 'text'
    assert.deepEqual actual, new VNode('div', {className: 'hoge piyo', id: 'foo'}, [new VText('text')])

  it 'generates node with cildren', ->
    expected = new VNode 'div', {className: 'root', style: {width: '100px'} }, [
      new VNode 'p', {}, [new VText 'hoge']
      new VNode 'button', {id: 'button1'}, [new VText 'click me']
    ]
    actual = vtreeKup (k) ->
      k.div '.root', style: {width: '100px'}, ->
        k.p 'hoge', ->
        k.button '#button1', 'click me'
    assert.deepEqual actual, expected

  it 'can generate inline elements easily', ->
    expected = new VNode 'div', {}, [
      new VText('piyo')
      new VNode('span', {}, [new VText 'hoge'])
      new VText('foo')
    ]
    actual = vtreeKup (k) ->
      k.div 'piyo', (-> k.span 'hoge'), 'foo'
    assert.deepEqual actual, expected

  it 'throws error if more than 1 element added to root', ->
    wrong = ->
      vtreeKup (k) ->
        k.div()
        k.div()
    assert.throws(wrong, Error)

  describe '#$add', ->

    it 'inserts a virtual-dom node', ->
      actual = vtreeKup (k) ->
        k.$add new VNode('div')
      assert.deepEqual actual, new VNode('div')

    it 'inserts virtual-dom nodes', ->
      actual = vtreeKup (k) ->
        k.$add [new VNode('div')]
      assert.deepEqual actual, new VNode('div')
