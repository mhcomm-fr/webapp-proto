###*
 # @ngdoc function
 # @name webappProtoApp.service:notification
 # @description
 # # notification
 # Service of the webappProtoApp
###


angular.module('webappProtoApp')
  .factory('NotifSvc', ($window, $timeout) ->
    result = 'denied'
    Notification.requestPermission()
  
    addNotif = () ->
      notification = new Notification("Hi there!",{body:'I am here to talk about HTML5 Web Notification API',icon:'icon.png',dir:'auto'})
      $timeout(()->
        notification.close()
      , 2000)
    
    return {
      addNotif: addNotif 
    }
  )