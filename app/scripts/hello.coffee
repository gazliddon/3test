
define (require) ->

  _ =       require 'underscore'
  THREE =   require 'THREE'
  $ =       require 'jquery'

  P2 =      require 'poly2tri'
  Clip =    require 'clipper'

  GazArrow = require './gazarrow'

  Colors = require './colors'
  
  box1 =
    [
      [0,0,0],
      [2,0,0],
      [2,2,0],
      [0,2,0],
    ]

  # 2d convex poly aligned to x,y plane

  class Poly
    constructor: (@data) ->
      @verts =  for _v in @data
        ray : []
        vert: new THREE.Vector3 _v[0],_v[1],_v[2]

      tvec = new THREE.Vector3

      @rays = for _i in [0 ... @verts.length]

        v0 = @verts[_i]
        v1 = @verts[(_i+1) % @verts.length]

        tvec.subVectors v1.vert, v0.vert
        norm = new THREE.Vector3 tvec.y, -tvec.x, 0
        r = new THREE.Ray v0.vert.clone(),norm.normalize()
        v0.ray.push r
        v1.ray.push r
        r

    # Check each vert to so if it's showing an edge to thus point

    getEdgeVerticies: (_p) ->
      t0 = new THREE.Vector3
      ret = _.chain(@verts).filter (_v) ->
        _v.ray.length == 2
      .filter (_v) ->
        t0.subVectors _p, _v.vert
        ( _v.ray[0].direction.dot(t0) * _v.ray[1].direction.dot(t0) ) < 0
      .value()
      ret


  class TestClass

    testIt: ->
      @p = new Poly box1
      geo = new THREE.Geometry
      geo.vertices.push _v.vert for _v in @p.verts
      geo.vertices.push @p.verts[0].vert
      @me = new THREE.Line geo, new THREE.LineBasicMaterial
      @me.position.set 0,0,0

    constructor: (@elem) ->
      console.log 'This is clipper'
      console.log Clip

      console.log 'This is poly2tri'
      console.log P2

      @testIt()

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

      @makeArrowPool()

      @vel = new THREE.Vector3 0.25,0.13,0

      @scene.add @me

      redraw = =>
        window.requestAnimationFrame redraw
        @draw()

      redraw()


    makeArrowPool: ->
      MAX_ARROWS = 100
      @arrows = for [0 ... MAX_ARROWS]
        new GazArrow()
      @scene.add _arr.arr for _arr in @arrows

    genArrows: (_pos, _item) ->
      _o.setVisible false for _o in @arrows
      verts = _item.getEdgeVerticies _pos
      tVec = new THREE.Vector3

      for _i in [0...verts.length]
        v = verts[_i].vert; a = @arrows[_i]
        a.set v, tVec.subVectors(v, _pos).normalize(), true

    resize: ->

    draw: ->
      home = new THREE.Vector3 0,0,0
      diff = new THREE.Vector3 @mesh.position
      diff.subVectors home,@mesh.position
      diff.divideScalar 400
      @vel.add diff
      @mesh.position.add @vel

      @genArrows @mesh.position, @p

      @renderer.setClearColor 0x0000f0,1
      @renderer.render @scene, @camera


