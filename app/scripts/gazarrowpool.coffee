define (require) ->
  THREE =       require 'THREE'
  GazArrow =    require './gazarrow'

  class GazArrowPool
    constructor: (@scene, @numArrows) ->
      @arrows = for [0 ... @numArrows]
        new GazArrow()
      @scene.add _arr.arr for _arr in @arrows
      @reset()

    reset: ->
      _o.setVisible false for _o in @arrows
      @index = 0


    drawArrow: (_pos, _dir) ->
      if @index != @numArrows
        a = @arrows[@index]
        a.set _pos, _dir, true
        @index++

    drawLine: (_p0, _p1) ->
      tvec = new THREE.Vector3
      tvec.subVectors _p1, _p0
      @drawArrow _p0, tvec
  
    drawPoly: (_verts) ->
      for _i in [0 ... _verts.length]
        v0 = _verts[_i]
        v1 = _verts[(_i+1) % _verts.length]
        tv = new THREE.Vector3
        tv.subVectors v1,v0
        @drawArrow v0, tv



