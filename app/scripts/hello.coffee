
define (require) ->

  _ =        require 'underscore'
  THREE =    require 'THREE'
  $ =        require 'jquery'

  P2 =       require 'poly2tri'
  Clip =     require 'clipper'

  GazArrow = require './gazarrow'
  Colors =   require './colors'
  Poly =     require './poly'
  
  items = [
    [ [0,0,0],
      [2,0,0],
      [2,2,0],
      [0,2,0],
    ],

    [ [2.5,1,0],
      [4.5,1,0],
      [4.5,3,0],
      [2.5,5,0]] ]


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


  class PolyTest
    constructor: (@polyData) ->
      @polys = for _p in @polyData
        @makePolyAndLine _p

    makePolyAndLine: (_i) ->
      p = new Poly _i
      geo = new THREE.Geometry
      geo.vertices.push _v.vert for _v in p.verts
      geo.vertices.push p.verts[0].vert
      line = new THREE.Line geo, new THREE.LineBasicMaterial
      { poly: p, line: line}


  class TestClass

    constructor: (@elem) ->
      console.log 'This is clipper'
      console.log Clip

      console.log 'This is poly2tri'
      console.log P2

      @container = $(@elem)

      @width = @container.width()
      @height = @container.height()
      @aspect = @width / @height

      # Make the renderer
      @renderer = new THREE.WebGLRenderer
        antialias: true

      @renderer.setSize( @width, @height )
      @container.append( @renderer.domElement )
      
      # Make the scena
      @scene = new THREE.Scene()
      @camera = new THREE.PerspectiveCamera(50, @aspect, 1, 10000)
      
      # Place camera on y axis
      @camera.position.set(0,0,15)
      @camera.up = new THREE.Vector3(0,1,0)
      @camera.lookAt new THREE.Vector3(0,0,0)
      
      @geometry = new THREE.CubeGeometry(1, 1, 1)
      @material = new THREE.MeshLambertMaterial({color: 0xf0f0f0})
      @mesh = new THREE.Mesh(@geometry, @material)
      @mesh.position.set(0,4,0)
      @scene.add(@mesh)


      # Add some lights
      @ambient = new THREE.AmbientLight( 0x808080 )
      @scene.add( @ambient )
      pointLight =new THREE.PointLight 0xa0a0a0
      pointLight.position.set 10,50, 130
      @scene.add(pointLight)

      @arrows = new GazArrowPool @scene, 100
 
      @vel = new THREE.Vector3 0.25,0.13,0

      @scene.add @me

      @ptest = new PolyTest items
      for _p in @ptest.polys
        @scene.add _p.line

      redraw = =>
        window.requestAnimationFrame redraw
        @draw()

      redraw()

    genArrows: (_pos, _item) ->
      verts = _item.getEdgeVerticies _pos
      tVec = new THREE.Vector3
      for _i in [0...verts.length]
        v = verts[_i].vert
        @arrows.drawArrow v, tVec.subVectors(v, _pos).normalize()

    resize: ->

    draw: ->
      home = new THREE.Vector3 0,0,0
      diff = new THREE.Vector3 @mesh.position
      diff.subVectors home,@mesh.position
      diff.divideScalar 400
      @vel.add diff
      @mesh.position.add @vel

      @arrows.reset()

      for _p in @ptest.polys
        @genArrows @mesh.position, _p.poly

      @renderer.setClearColor 0x0000f0,1
      
      @renderer.render @scene, @camera

