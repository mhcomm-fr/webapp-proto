###*
 # @ngdoc function
 # @name webappProtoApp.service:notification
 # @description
 # # notification
 # Service of the webappProtoApp
###


angular.module('webappProtoApp')
  .factory('NotifSvc', ($window, $timeout) ->
    if Notification.permission isnt "granted"
      Notification.requestPermission (perm) ->
        Notification.permission = perm

    onError = () ->
      console.log 'error on notif'
    onShow = () ->
      console.log 'showing notif'
    onClick = () ->
      console.log 'click on notif'
    onClose = () ->
      console.log 'closing notif'

    addNotif = (title, options) ->
      console.log 'permision : ', Notification.permission

      # notification = new Notification title, options
      notification = new Notification title, options
      notification.onerror = onError
      notification.onclick = onClick
      notification.onshow = onShow
      notification.onclose = onClose

      $timeout( ()->
        notification.close()
      , 5000)

      return notification

    return {
      addNotif: addNotif
    }
  )
.run (NotifSvc, $timeout) ->
  console.log 'run of notif'
  notif = NotifSvc.addNotif 'test', {body:'I am here to be sure that notifications works', dir:'auto', icon:'https://taiga.mhcomm.fr/images/favicon.png', TAG:"NOTIF"}
