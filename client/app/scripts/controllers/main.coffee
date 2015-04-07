'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'MainCtrl', ($scope, messageSrv, $state, $localStorage, utils) ->

    #$scope.messages = message.messages
    $scope.messages = []

    messageSrv.query().$promise.then (messages) ->
      $scope.messages = messages

    $scope.new = new messageSrv({author:$scope.user.id, content: "", uid:utils.genUUID()})

    $scope.save = () ->
      $scope.new.$save().then () ->
        messageSrv.query().$promise.then (messages) ->
          $scope.messages = messages

        $scope.new = new messageSrv({author:$scope.user.id, content: "", uid:utils.genUUID()})

