'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'MainCtrl', ($scope, syncMessage, $state, $localStorage, utils, tx, connectionStatus) ->

    $scope.messages = []

    $scope.install = () ->
      manifestUrl = '/manifest.webapp';
      req = navigator.mozApps.install(manifestUrl)
      req.onsuccess = () ->
          alert(this.result.origin)
      req.onerror = () ->
          alert(this.error.name)

    $scope.msgSrv = syncMessage

    $scope.new = syncMessage.new({author:$scope.user.id, content: "", uid:utils.genUUID()})

    $scope.save = () ->
      $scope.new.$save().then () ->

        $scope.new = syncMessage.new({author:$scope.user.id, content: "", uid:utils.genUUID()})
        
  .run (PushNotifSvc, syncMessage) ->
    PushNotifSvc.reSetHandler()
    console.log 'launching RUN'
    PushNotifSvc.register('msg', (version) ->
      console.log('bla  ', version)
      syncMessage.fetch()
    )
