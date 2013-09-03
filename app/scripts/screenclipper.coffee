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

      clipPolygons = new ClipperLib.Polygons()
      clipPolygons.push @polygonToClipWith
      cpr.AddPolygons clipPolygons , ClipperLib.PolyType.ptClip
      
      subjPolygons = new ClipperLib.Polygons()
      subjPolygons.push @pointsToUpScaledPoly _poly
      cpr.AddPolygons subjPolygons, ClipperLib.PolyType.ptSubject

      out = [[]]

      cpr.Execute clipType, out, ClipperLib.PolyFillType.pftNonZero, ClipperLib.PolyFillType.pftNonZero
      
      ([ _v.X / @scale, _v.Y / @scale ] for _v in out[0])


