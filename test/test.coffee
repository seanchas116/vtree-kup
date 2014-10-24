assert = (require 'chai').assert
vtreeKup = require '../index'
VNode = require 'vtree/vnode'
VText = require 'vtree/vtext'

describe 'vtreeKup', ->

  it 'generates node', ->
    assert.deepEqual new VNode('div'),
      vtreeKup (k) ->
        k.div()

  it 'generates node with properties', ->
    assert.deepEqual new VNode('div', {style: {display: 'none'}}),
      vtreeKup (k) ->
        k.div style: {display: 'none'}

  it 'generates node with class/id', ->
    assert.deepEqual new VNode('div', {class: 'hoge piyo', id: 'foo'}, [new VText('text')]),
      vtreeKup (k) ->
        k.div '.hoge.piyo#foo', 'text'

  it 'generates node with cildren', ->
    expected = new VNode 'div', {class: 'root', style: {width: '100px'} }, [
      new VNode 'p', {}, [new VText 'hoge']
      new VNode 'button', {id: 'button1'}, [new VText 'click me']
    ]
    actual = vtreeKup (k) ->
      k.div '.root', style: {width: '100px'}, ->
        k.p 'hoge', ->
        k.button '#button1', 'click me'
    assert.deepEqual actual, expected

  it 'generates', ->
    expected = new VNode 'div', {}, [
      new VText('piyo')
      new VNode('span', {}, [new VText 'hoge'])
      new VText('foo')
    ]
    actual = vtreeKup (k) ->
      k.div 'piyo', (-> k.span 'hoge'), 'foo'
    assert.deepEqual actual, expected
