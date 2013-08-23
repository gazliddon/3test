
obj = [
  [ 0.11774731, 0.98961514, 0.0],
  [ 0.67774004, 0.9883912, 0.0],
  [ 0.8310509, 0.95687395, 0.0],
  [ 0.9920345, 0.8808236, 0.0],
  [ 0.9953164, 0.61370814, 0.0],
  [ 0.9828928, 3.2733142e-2, 0.0],
  [ 0.95453143, 1.8860936e-2, 0.0],
  [ 0.8703773, 1.1655092e-3, 0.0],
  [ 0.71696794, 8.0269575e-4, 0.0],
  [ 0.1046952, 6.6679716e-3, 0.0],
  [ 5.395615e-2, 2.4766564e-2, 0.0],
  [ 1.930505e-2, 0.14342946, 0.0],
  [ 1.3690412e-2, 0.22301978, 0.0],
  [ 1.4182925e-3, 0.95569515, 0.0]
]

makeTextSprite = (message, parameters) ->
  parameters = {}  if parameters is `undefined`
  fontface = (if parameters.hasOwnProperty("fontface") then parameters["fontface"] else "Arial")
  fontsize = (if parameters.hasOwnProperty("fontsize") then parameters["fontsize"] else 18)
  borderThickness = (if parameters.hasOwnProperty("borderThickness") then parameters["borderThickness"] else 4)
  borderColor = (if parameters.hasOwnProperty("borderColor") then parameters["borderColor"] else
    r: 0
    g: 0
    b: 0
    a: 1.0
  )
  backgroundColor = (if parameters.hasOwnProperty("backgroundColor") then parameters["backgroundColor"] else
    r: 255
    g: 255
    b: 255
    a: 1.0
  )
  spriteAlignment = THREE.SpriteAlignment.topLeft
  canvas = document.createElement("canvas")
  context = canvas.getContext("2d")
  context.font = "Bold " + fontsize + "px " + fontface
  
  # get size data (height depends only on font size)
  metrics = context.measureText(message)
  textWidth = metrics.width
  
  # background color
  context.fillStyle = "rgba(" + backgroundColor.r + "," + backgroundColor.g + "," + backgroundColor.b + "," + backgroundColor.a + ")"
  
  # border color
  context.strokeStyle = "rgba(" + borderColor.r + "," + borderColor.g + "," + borderColor.b + "," + borderColor.a + ")"
  context.lineWidth = borderThickness
  roundRect context, borderThickness / 2, borderThickness / 2, textWidth + borderThickness, fontsize * 1.4 + borderThickness, 6
  
  # 1.4 is extra height factor for text below baseline: g,j,p,q.
  
  # text color
  context.fillStyle = "rgba(0, 0, 0, 1.0)"
  context.fillText message, borderThickness, fontsize + borderThickness
  
  # canvas contents will be used for a texture
  texture = new THREE.Texture(canvas)
  texture.needsUpdate = true
  spriteMaterial = new THREE.SpriteMaterial(
    map: texture
    useScreenCoordinates: false
    alignment: spriteAlignment
  )
  sprite = new THREE.Sprite(spriteMaterial)
  sprite.scale.set 1, 1, 1.0
  sprite

# function for drawing rounded rectangles
roundRect = (ctx, x, y, w, h, r) ->
  ctx.beginPath()
  ctx.moveTo x + r, y
  ctx.lineTo x + w - r, y
  ctx.quadraticCurveTo x + w, y, x + w, y + r
  ctx.lineTo x + w, y + h - r
  ctx.quadraticCurveTo x + w, y + h, x + w - r, y + h
  ctx.lineTo x + r, y + h
  ctx.quadraticCurveTo x, y + h, x, y + h - r
  ctx.lineTo x, y + r
  ctx.quadraticCurveTo x, y, x + r, y
  ctx.closePath()
  ctx.fill()
  ctx.stroke()


define (require) ->
  _ =        require 'underscore'
  THREE =    require 'THREE'
  $ =        require 'jquery'

  P2 =       require 'poly2tri'
  Clip =     require 'clipper'

  GazArrow = require './gazarrow'
  Colors =   require './colors'
  Poly =     require './poly'
  
  items1 = [
    [ [0,0,0],
      [2,0,0],
      [2,2,0],
      [0,2,0],
    ],
    [ [2.5,1,0],
      [4.5,1,0],
      [4.5,3,0],
      [2.5,5,0]] ]

  items = [ obj ]

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
      @camera.position.set(0,0,3)
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

      attrs =
        fontsize: 32
        backgroundColor:
          r:100
          g:255
          b:100
          a:1

      i = 0
      for _p in @ptest.polys
        @scene.add _p.line
        for _poly in @ptest.polyData
          for _v in _poly
            t = makeTextSprite " "+i+" ", attrs
            t.scale.fromArray [0.5,0.5,0.5]
            t.position.fromArray _v
            @scene.add t
            i++


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
          shadowPolys.push p.line
          @scene.add p.line
  
      @renderer.setClearColor 0x0000f0,1
      @renderer.render @scene, @camera

      @scene.remove _l for _l in shadowPolys

