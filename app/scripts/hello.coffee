
obj = [
  [4.258526651067196e-2,0.9038111336367954]
,[9.266341274556411e-2,0.9442352098451056]
,[0.2764148736226003,0.9907971986038043]
,[0.8941779408851765,0.9958862886700675]
,[0.9738796361307129,0.9193944312070681]
,[0.9763210589830909,0.2977977544559932]
,[0.9618442887371168,0.17179418102020383]
,[0.9392606136850937,4.344026077460206e-3]
,[0.47374288977160883,1.754781108775727e-2]
,[0.1890946738046143,4.4369441591774694e-2]
,[2.5989561886069268e-2,0.1459792010236184]
]

define (require) ->
  _ =           require 'underscore'
  THREE =       require 'THREE'
  $ =           require 'jquery'

  GazArrow =    require './gazarrow'
  Colors =      require './colors'
  Poly =        require './poly'
  ScreenClipper = require './screenclipper'
  GazArrowPool =  require './gazarrowpool'

  width = 5
  height = 5
  wD2 = width / 2
  hD2 = height / 2

  borderPoly  = [
    [ -wD2, -hD2],
    [ wD2, -hD2],
    [ wD2, hD2],
    [ -wD2, hD2],
  ]

  items = [ obj ]

  makePolyAndLine = (_i) ->
    p = new Poly _i
    geo = new THREE.Geometry
    geo.vertices.push _v.vert for _v in p.verts
    geo.vertices.push p.verts[0].vert
    line = new THREE.Line geo, new THREE.LineBasicMaterial
    { poly: p, line: line}

  class PolyTest
    constructor: (@polyData) ->
      @polys = for _p in @polyData
        makePolyAndLine _p

  class TestClass

    constructor: (@elem) ->
      @clipper = new ScreenClipper borderPoly

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
      @camera.position.set(0,0,16)
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

      @arrows = new GazArrowPool @scene, 1000
 
      @vel = new THREE.Vector3 0.25,0.13,0
      @scene.add @me

      @ptest = new PolyTest items

      @bploy = makePolyAndLine borderPoly
      @scene.add @bploy.line

      redraw = =>
        window.requestAnimationFrame redraw
        @draw()

      redraw()

    resize: ->

    draw: ->
      home = new THREE.Vector3 0,0,0
      diff = new THREE.Vector3 @mesh.position
      diff.subVectors home,@mesh.position
      diff.divideScalar 400
      @vel.add diff
      @mesh.position.add @vel

      @arrows.reset()

      shadowPolys = []
  
      for _p in @ptest.polys
        z = _p.poly.makeShadowExtrusion @mesh.position, 25.5
        if z.length
          p = makePolyAndLine z
          @clipper.clipPolygon p.poly.data
          shadowPolys.push p.line
          @scene.add p.line
  
      @renderer.setClearColor 0x0000f0,1
      @renderer.render @scene, @camera

      @scene.remove _l for _l in shadowPolys

