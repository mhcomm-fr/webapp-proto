'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
