###*
 # @ngdoc function
 # @name webappProtoApp.service:notification
 # @description
 # # notification
 # Service of the webappProtoApp
###


angular.module('webappProtoApp')
  .factory('NotifSvc', ($window, $timeout) ->
    if !Notification?
      console.log('No desktop notification on this platform !')
      return {
        addNotif: (title, options) ->
          console.log('Should notify ' + title + ": " + options)
      }

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
