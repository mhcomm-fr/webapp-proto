'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the webappProtoApp
###
angular.module('webappProtoApp')
  .controller 'TestCtrl', (cordova, $cordovaDevice,  $cordovaDialogs, $cordovaLocalNotification) ->
      console.log('test')

      cordova.ready.then () ->
        console.log('Cordova loaded')
        device = $cordovaDevice.getDevice()
        console.log(device.model)
        console.log(device.cordova)
        console.log(device.platform)
        console.log(device.uuid)
        console.log(device.version)


        $cordovaDialogs.alert('The super message', 'A title', 'Okayyyyy')
        .then () ->
          console.log('donnnnnnne')


        $cordovaLocalNotification.schedule({
          id: 1,
          title: 'Super notif',
          text: 'Webapp proto is actually working',
          data: {
            customProperty: 'custom value'
          }
        }).then (result) ->
          console.log('Dooooone tooo')



