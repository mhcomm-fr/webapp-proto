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
    'ngTouch',
    'offline'
  ])
  .config ($stateProvider, $urlRouterProvider, $resourceProvider, $httpProvider) ->
    $resourceProvider.defaults.stripTrailingSlashes = false;
    $httpProvider.defaults.xsrfCookieName = 'csrftoken';
    $httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken';
    #$urlRouterProvider.otherwise("/user/main")
    $urlRouterProvider.otherwise("/test")
    
    $stateProvider
    .state('test', {
      url: "/test"
      templateUrl: "views/test.html"
      controller: 'TestCtrl'
    })
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
  ###.run ($rootScope, connectionStatus) ->
    $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
      console.log(error)

    $rootScope.isOnline = connectionStatus.isOnline()

    connectionStatus.$on 'online', () ->
      console.log('Go Online')
      $rootScope.isOnline = true

    connectionStatus.$on 'offline', () ->
      console.log('Go offline')
      $rootScope.isOnline = false

  .run (PushNotifSvc, syncMessage, NotifSvc) ->
    PushNotifSvc.reSetHandler()
    console.log 'launching RUN'
    PushNotifSvc.register('msg', (version) ->
      console.log('bla  ', version)
      syncMessage.fetch().then ()->
        messages = syncMessage.getData()
        message = messages[0].content
        console.log 'rcv message : ',message
        options={
          TAG:'msg',
          icon:"https://taiga.mhcomm.fr/images/favicon.png",
          body:'message : "'+message+'"',
          dir:'rtl'
        }
        NotifSvc.addNotif 'new msg receive', options
    )

  .run (NotifSvc, $timeout) ->
    console.log 'run of notif'
    notif = NotifSvc.addNotif 'test', {body:'I am here to be sure that notifications works', dir:'auto', icon:'https://taiga.mhcomm.fr/images/favicon.png', TAG:"NOTIF"}

  ###
