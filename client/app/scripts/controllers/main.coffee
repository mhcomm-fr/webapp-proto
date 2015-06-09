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
    $scope.tx = tx.tx

    syncMessage.query().$promise.then (messages) ->
      $scope.messages = messages

    $scope.new = syncMessage.new({author:$scope.user.id, content: "", uid:utils.genUUID()})

    $scope.save = () ->
      $scope.new.$save().then () ->
        syncMessage.query().$promise.then (messages) ->
          $scope.messages = messages

        $scope.new = syncMessage.new({author:$scope.user.id, content: "", uid:utils.genUUID()})

    $scope.$on "messagesUpdated", () -> 
      console.log("messagesUpdated")
      syncMessage.query().$promise.then (messages) ->
        $scope.messages = messages
        
