'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # LoginCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'LoginCtrl', ($scope, $rootScope, user, $state) ->
    $scope.credentials = {}
    $scope.loginFailed = false
    $scope.login = () ->
      {username, password} = $scope.credentials
      if user.checkLogin(username, password)
        $rootScope.currentUser = user.getUser(username)
        $state.go('main')
      else
        $scope.loginFailed = true