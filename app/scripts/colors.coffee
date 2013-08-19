define (require) ->
  Util = require './util'

  class ColorUtil

    @floatToHex: (r,g,b) ->
      r = (Math.abs(r) % 1)* 255
      g = (Math.abs(g) % 1)* 255
      b = (Math.abs(b) % 1)* 255
      Math.floor r + (g * 256) + (b * 256 * 256)

    @componentToHex: (c) ->
      hex = c.toString 16
      hex = "0" + hex if hex.length == 1
      hex

    @rgbToHex: (r, g, b) ->
      str = "#"
      str += ColorUtil.componentToHex(r)
      str += ColorUtil.componentToHex(g)
      str += ColorUtil.componentToHex (b)
      str

    @rgbFloatToHex: (r,g,b) ->
      xform = (_v) ->
        Math.floor( (Util.clamp 0, 1,_v) * 255)

      @rgbToHex xform(r), xform(g), xform(b)

    @hexToRgb: (hex) ->
      # Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
      shorthandRegex = /^\#?([a-f\d])([a-f\d])([a-f\d])$/i

      func = (m, r, g, b) ->
        r + r + g + g + b + b
            
      hex = hex.replace shorthandRegex, func
    
      result = /^\#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec hex

      ret =
        r: parseInt result[1], 16
        g: parseInt result[2], 16
        b: parseInt result[3], 16


  class Color
    constructor: ->
      @r = 1
      @g = 1
      @b = 1

    hex: ->
      ColorUtil.rgbFloatToHex @r, @g, @b

    blend: (_colA, _colB, _t) ->
      _t = Util.clamp 0,1,_t

      interp = (a,b,t) ->
        a+((b-a) * t)

      @r = interp _colA.r, _colB.r, _t
      @g = interp _colA.g, _colB.g, _t
      @b = interp _colA.b, _colB.b, _t
      @


  ColorUtil: ColorUtil
  Color: Color
