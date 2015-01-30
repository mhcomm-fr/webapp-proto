'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'MainCtrl', ($scope, $rootScope, message, $state) ->
    if not $rootScope.currentUser?
      $state.go('login')

    $scope.user = $rootScope.currentUser
    $scope.messages = message.messages
    $scope.new = {content:''}

    $scope.save = () ->
      message.newMessage($scope.new.content, $rootScope.currentUser)

