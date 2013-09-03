define (require) ->

  ClipperLib =  require 'clipper'

  class ScreenClipper
    pointsToUpScaledPoly: (_points) ->
      poly = new ClipperLib.Polygon()

      for _v in _points
        p = new ClipperLib.IntPoint _v[0]*@scale, _v[1]*@scale
        poly.push p
      poly

    constructor : (@pos, @dims) ->
      @scale = 4096
      wd2 = (@dims[0]/2);  hd2 = (@dims[1]/2)
      
      clipPoly = [ [-wd2, hd2],[wd2,hd2],[wd2,-hd2],[-wd2,-hd2]]
      
      @polygonToClipWith = @pointsToUpScaledPoly clipPoly

    clipPolygon : (_poly) ->
      clipType = ClipperLib.ClipType.ctUnion
      subject_fillType = ClipperLib.PolyFillType.pftNonZero
      clip_fillType = ClipperLib.PolyFillType.pftNonZero

      cpr = new ClipperLib.Clipper()
      cpr.AddPolygon @polygonToClipWith, ClipperLib.PolyType.ptClip
      
      subjPolygon = @pointsToUpScaledPoly _poly
      cpr.AddPolygons subjPolygon, ClipperLib.PolyType.ptSubject

      out = [[]]

      cpr.Execute clipType, out, subject_fillType, clip_fillType
      
      [ _v[0] / @scale, _v[1] / @scale ] for _v in out


