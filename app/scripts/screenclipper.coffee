define (require) ->
  ClipperLib =  require 'clipper'

  class ScreenClipper
    pointsToUpScaledPoly: (_points) ->
      poly = new ClipperLib.Polygon()
      poly.push(new ClipperLib.IntPoint _v[0]*@scale, _v[1]*@scale) for _v in _points
      poly

    constructor : (@points) ->
      @scale = 4096
      @polygonToClipWith = @pointsToUpScaledPoly @points

    clipPolygon : (_poly) ->
      clipType = ClipperLib.ClipType.ctUnion

      cpr = new ClipperLib.Clipper()
      cpr.AddPolygon @polygonToClipWith, ClipperLib.PolyType.ptClip
      
      subjPolygon = @pointsToUpScaledPoly _poly
      cpr.AddPolygons subjPolygon, ClipperLib.PolyType.ptSubject

      out = [[]]

      cpr.Execute clipType, out, ClipperLib.PolyFillType.pftNonZero, ClipperLib.PolyFillType.pftNonZero
      
      [ _v[0] / @scale, _v[1] / @scale ] for _v in out


