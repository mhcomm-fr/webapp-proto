'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'UserCtrl', ($scope, userSrv, $state, currentUser) ->

    if not currentUser
      userSrv.gotoLogin()

    $scope.user = currentUser

    $scope.disconnect = () ->
      userSrv.logout()