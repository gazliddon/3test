require.config({
  paths: {
    jquery:       '../bower_components/jquery/jquery',
    underscore:   '../bower_components/underscore/underscore',
    THREE:        '../bower_components/threejs/build/three',
    poly2tri:     'vendor/poly2tri',
    clipper:      'vendor/clipper'
  },
  
  shim: {
    THREE:        { exports: 'THREE'},
    underscore :  { exports : '_'},
    clipper :     { exports : 'ClipperLib'},
    poly2tri :    { exports : 'poly2tri'}
  }

});

// Shim to give us a reliable request animation frame

(function() {
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];

    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelRequestAnimationFrame = window[vendors[x]+
          'CancelRequestAnimationFrame'];
    }

    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); }, 
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };

    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}())

require(['app', 'jquery','hello'], function (app, $,  Hello) {
  'use strict';
  console.log('Running jQuery %s', $().jquery);
  var app = new Hello('#container');
});

