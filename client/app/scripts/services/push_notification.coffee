###*
 # @ngdoc function
 # @name webappProtoApp.service:PushNotificationSvc
 # @description
 # # PushNotificationSvc
 # Service of the webappProtoApp
###

angular.module('webappProtoApp')
  .factory('PushNotifSvc', ['$localStorage', '$window', '$q', '$http', 'clientSvc', 'NotifSvc', ($localStorage, $window, $q, $http, clientSvc, NotifSvc) ->
    callbacks = {}
    UID = clientSvc.getUID()


    isCompatible = $window.navigator.mozSetMessageHandler and $window.navigator.push

    reSetHandler = () ->
      $window.navigator.mozSetMessageHandler('push', cbPushNotif)
      # register endpoint change
      $window.navigator.mozSetMessageHandler 'push-register', (e) ->
        ###
          function for re register push-notifications
        ###
        console.log('in callback of re-push')
        console.log('push-register received, I need to register my endpoint(s) again!')

        tmpLocalCallbacks = callbacks
        callbacks = {}
        tmpLocalStorage = $localStorage.endPointsByName
        $localStorage.endPointsByUrl = {}
        $localStorage.endPointsByName = {}
        for endpoint, name of tmpLocalStorage
          registerPushNotification(name, tmpLocalCallbacks[name])

    if isCompatible
      ###
        initialize the module, you have to call it before other methods
        initalize main callback, and re-register functions
      ###
      console.log('initializing service PushNotifSvc')
      if ! $localStorage.endPointsByUrl
        $localStorage.endPointsByUrl = {}

      if ! $localStorage.endPointsByName
        $localStorage.endPointsByName = {}

    else
      # No message handler
      console.log('your web browser is not compatible with push notifications')

    register = (endPointName, cbFunc) ->
      ###
        register a new endpoint associated with name param, who call cbFunc when notify

        @apiParam endPointName  name of endoint
        @apiParam cbFunc  Function to call when endpoint is call

        @apiSuccess defer
        @apiError defer
      ###
      console.log("start register")
      defered = $q.defer()

      if !callbacks[endPointName]
        callbacks[endPointName] = $q.defer()

      #jerem's code
      if !$localStorage.endPointsByName[endPointName]
        req = navigator.push.register()
        req.onsuccess = (e) ->
          endpoint = req.result

          $localStorage.endPointsByName[endPointName] = {url:endpoint}
          $localStorage.endPointsByUrl[endpoint] = {name:endPointName}

          callbacks[endPointName].resolve(cbFunc)
          console.log("registering endoint " + endPointName + " with url " + endpoint)
          registerOnServer(endPointName, endpoint)
          defered.resolve(endpoint)

        req.onerror = (e) ->
          console.error("Error getting a new endpoint: " + JSON.stringify(e))
          defered.reject()
          callbacks[endPointName].reject()
      else
        callbacks[endPointName].resolve(cbFunc)
        defered.resolve($localStorage.endPointsByName[endPointName].url)
        registerOnServer(endPointName, $localStorage.endPointsByName[endPointName].url)

      return defered.promise

    # not work yet
    unregister = (endPointName) ->
      ###
         unregister an endpoint already register, specified by endPointName.

         @apiParam endPointName  name of endoint
      ###
      defered = $q.defer()
      endpointUrl = $localStorage.endPointsByName[endPointName].url
      if endpointUrl
        console.log('trying to untregister endpoint '+ endPointName)
        console.debug('with url '+ endpointUrl)
        req = navigator.push.unregister(endpointUrl)

        req.onsuccess = (e) ->
          endpoint = req.result
          if endpoint != endpointUrl
            console.log('both endpoint are not equals')

          $localStorage.endPointsByUrl[endpointUrl] = undefined
          $localStorage.endPointsByName[endPointName] = undefined

          callbacks[name] = undefined
          console.log('endpoint '+ endPointName+ ' unregistered')
          unregisterOnServer(endPointName)
          defered.resolve()

        req.onerror = (e) ->
          console.error("Error unregistering the endpoint: " + JSON.stringify(e));
          console.error(e);
          defered.reject()

      else
        console.error('cannot retrieve endpoint in localStorage')
        defered.resolve()
        unregisterOnServer(endPointName)
      return defered.promise


    cbPushNotif = (e) ->
      ###
        main callback for all push notification.
        this method will call the callback given to the register method.
      ###
      console.log('in cb receive push notif')
      endpoint = e.pushEndpoint
      version = e.version
      endPointName = $localStorage.endPointsByUrl[endpoint].name
      console.log('in push notif callback for '+ endPointName+ ' with version='+version)

      if !callbacks[endPointName]
        callbacks[endPointName] = $q.defer()

      callbacks[endPointName].promise.then (callback) ->
        callback(version)


    registerOnServer = (name, endpoint) ->
        registerUrl = '/api/client/register/'
        $http.post(registerUrl, {uid:UID, topic_name:name, endpoint_url:endpoint})

    unregisterOnServer = (name) ->
        unregisterUrl = '/api/client/unregister/'
        $http.post(unregisterUrl, {uid:UID, topic_name:name})

    cleanAllStorage = ()->
      callbacks = {}
      $localStorage.endPointsByUrl = {}
      $localStorage.endPointsByName = {}
      console.log 'internal structure of push niotification is now cleared'


    if isCompatible
      return {
        register:register,
        cleanAllStorage:cleanAllStorage,
        unregister:unregister,
        reSetHandler:reSetHandler
      }
    else
      return {
        cleanAllStorage:() ->  console.log('your web browser is not compatible with push notifications')
        register:(endPointName, cbFunc) -> console.log('your web browser is not compatible with push notifications'),
        unregister:(endPointName) -> console.log('your web browser is not compatible with push notifications'),
        reSetHandler: () ->  console.log('your web browser is not compatible with push notifications')
      }
])
# .run (PushNotifSvc, $localStorage) ->
#   PushNotifSvc.cleanAllStorage()
#   console.log $localStorage.endPointsByUrl
#   console.log $localStorage.endPointsByName
###
  console.log("lauching run of pushNotificationSvc")
  nameOfCallback = "ju_test"
  nameOfCallback2 = "ju_test2"
  PushNotifSvc.reSetHandler()
  PushNotifSvc.register nameOfCallback, (version) ->
      console.log('callback for '+nameOfCallback+' with version '+ version)
  PushNotifSvc.register nameOfCallback2, (version) ->
      console.log('callback for '+nameOfCallback2+' with version '+ version)###
###.run (PushNotifSvc, $http, $localStorage) ->
  console.log('lauching run of pushNotificationSvc')
  nameOfCallback = "f"

  PushNotifSvc.reSetHandler()

  promise = PushNotifSvc.register nameOfCallback, (version) ->
    console.log('callback for '+nameOfCallback+' with version '+ version)

  console.log($localStorage)
  promise.then (url) ->
    console.log('url : '+url)

  promise.then ()-> PushNotifSvc.unregister nameOfCallback###
