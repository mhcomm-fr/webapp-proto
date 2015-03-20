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
    'ngStorage',
    'ngTouch'
  ])
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise("/user/main")
    $stateProvider
    .state('user', {
      url: "/user"
      templateUrl: "views/base.html"
      controller: 'UserCtrl'
      resolve: {
        currentUser: (userSrv)->
          return userSrv.getLogged()
      }

    })
    .state('user.main', {
      url: "/main"
      templateUrl: "views/main.html"
      controller: 'MainCtrl'
    })
    .state('login', {
      url: "/login"
      templateUrl: "views/login.html"
      controller: 'LoginCtrl'
    })
  .run ($rootScope) ->
    $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
      console.log(error)