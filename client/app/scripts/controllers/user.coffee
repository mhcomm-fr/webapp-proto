'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'UserCtrl', ($scope, userSrv, $state) ->
    currentUser = userSrv.getLogged()

    if not currentUser?
      $state.go('login')

    $scope.user = currentUser

    $scope.disconnect = () ->
      userSrv.logout()
      $state.go('login')

