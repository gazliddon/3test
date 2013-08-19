define (require) ->
  Util =
      extend: (obj, mixin) ->
        obj[name] = method for name, method of mixin        
        obj

      include: (klass, mixin) ->
        Util.extend klass.prototype, mixin

      fract: (_v) ->
        _v - Math.floor _v

      clamp: (_min, _max, _v) ->
        _v = _min if _v < _min
        _v = _max if _v > _max
        _v

      interpolate: (_from, _to, _t) ->
        _from + ((_to - _from) * _t)

      step: ( _edge, _v) ->
        switch _v
          when _v < _lo then 0
          else 1

      saturate: (_val) ->
        Util.clamp 0, 1, _val

      smoothStep: (_edge0, _edge1, _v) ->
        t = Util.saturate (_v-_edge0) / (_edge1 - _edge0)
        t = t * t  * (3 - 2*t)
        t

      getRandIndex: (_maxNotInc) ->
        Math.floor Util.randRange(0, _maxNotInc)
  
      randRange: (_min, _max) ->
        range = _max - _min
        _min + Math.random() * range

      randRangeV2: (_v2) ->
        min = _v2[0]
        max = _v2[1]
        Util.randRange min, max

      randSign: (_v) ->
        _v = -_v if Util.rand() < 0.5
        _v

      rand: ->
        Math.random()

      getRandItem: (_arr) ->
        _arr[Util.getRandIndex(_arr.length)]

