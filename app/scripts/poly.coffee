define (require) ->
  THREE =   require 'THREE'
  
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

    getEdgeVerticies: (_p) ->
      t0 = new THREE.Vector3
      ret = _.chain(@verts).filter (_v) ->
        _v.ray.length == 2
      .filter (_v) ->
        t0.subVectors _p, _v.vert
        ( _v.ray[0].direction.dot(t0) * _v.ray[1].direction.dot(t0) ) < 0
      .value()
      ret

