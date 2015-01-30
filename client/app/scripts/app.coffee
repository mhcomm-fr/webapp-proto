'use strict'

###*
 # @ngdoc overview
 # @name webappProtoApp
 # @description
 # # webappProtoApp
 #
 # Main module of the application.
###
angular
  .module('webappProtoApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ui.router',
    'ngTouch'
  ])
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise("/login")
    $stateProvider
    .state('main', {
      url: "/main"
      templateUrl: "views/main.html"
      controller: 'MainCtrl'
    })
    .state('login', {
      url: "/login"
      templateUrl: "views/login.html"
      controller: 'LoginCtrl'
    })