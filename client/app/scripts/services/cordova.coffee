'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:cordova
 # @description
 # # CordovaCTRL
 # Controller of the webappProtoApp
###


angular.module('webappProtoApp')
  .factory('cordova', ['$q', '$window', '$timeout', ($q, $window, $timeout) ->
    d = $q.defer()
    resolved = false

    document.addEventListener 'deviceready', () ->
      resolved = true
      d.resolve($window.cordova)

    # Check to make sure we didn't miss the
    # event (just in case)
    $timeout () ->
      if !resolved
        if $window.cordova
           d.resolve($window.cordova)
    , 3000

    # Public API here
    return {
      'ready': d.promise
    }
])



