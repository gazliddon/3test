define (require) ->

  THREE =   require 'THREE'

  class GazArrow
    constructor: ->
      @pos = new THREE.Vector3 0,0,0
      @arr = new THREE.ArrowHelper (new THREE.Vector3 0,1,0), @pos,3

    set: (_pos, _dir, _vis) ->
      @pos.copy _pos
      @arr.setDirection _dir
      @setVisible _vis
      @

    setVisible: (_val)->
      @arr.line.visible = _val
      @arr.cone.visible = _val
      @

