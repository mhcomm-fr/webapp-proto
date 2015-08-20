'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'MainCtrl', ($scope, syncMessage, $state, $localStorage, utils, $location, cordova) ->

    cordova.ready.then () ->
      console.log('Cordova loaded')

    $scope.messages = []

    $scope.install = () ->
      manifestUrl = $location.protocol() + "://" + $location.host() + ":" + $location.port() + '/manifest.webapp'
      console.log(manifestUrl)
      req = navigator.mozApps.install(manifestUrl)
      console.log('ok')
      req.onsuccess = () ->
          console.log('Youhou')
          console.log(this.result.origin)
      req.onerror = () ->
          console.log('Hoooooo')
          console.log(this.error.name)

    $scope.msgSrv = syncMessage

    $scope.new = syncMessage.new({author:$scope.user.id, content: "", uid:utils.genUUID()})

    $scope.save = () ->
      $scope.new.$save().then () ->

        $scope.new = syncMessage.new({author:$scope.user.id, content: "", uid:utils.genUUID()})

