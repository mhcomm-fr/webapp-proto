'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'MainCtrl', ($scope, messageSrv, $state, $localStorage) ->

    #$scope.messages = message.messages
    $scope.$localStorage = $localStorage
    $scope.messages = []

    messageSrv.query().$promise.then (messages) ->
      $scope.messages = messages

    $scope.new = {content: ''}

    $scope.save = () ->
      message.newMessage($scope.new.content, $scope.user)
      $scope.new.content = ''

