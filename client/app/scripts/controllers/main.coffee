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
      manifestUrl = './manifest.webapp';
      req = navigator.mozApps.installPackage(manifestUrl)
      req.onsuccess = () ->
          alert(this.result.origin)
      req.onerror = () ->
          alert(this.error.name)


    $scope.msgSrv = syncMessage

    #syncMessage.query().$promise.then (messages) ->
    #  $scope.messages = messages

    $scope.new = syncMessage.new({author:$scope.user.id, content: "", uid:utils.genUUID()})

    $scope.save = () ->
      $scope.new.$save().then () ->
        #syncMessage.query().$promise.then (messages) ->
        #  $scope.messages = messages

        $scope.new = syncMessage.new({author:$scope.user.id, content: "", uid:utils.genUUID()})

    ###$scope.$on "messagesUpdated", () ->
      console.log("messagesUpdated")
      syncMessage.query().$promise.then (messages) ->
        $scope.messages = messages###
        
  .run (PushNotifSvc, syncMessage) ->
    PushNotifSvc.reSetHandler()
    console.log 'launching RUN'
    PushNotifSvc.register('msg', (version) ->
      console.log('bla  ', version)
      syncMessage.fetch()
    )
