'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'MainCtrl', ($scope, message, $state) ->

    $scope.messages = message.messages
    $scope.new = {content: ''}

    $scope.save = () ->
      message.newMessage($scope.new.content, $scope.user)
      $scope.new.content = ''

