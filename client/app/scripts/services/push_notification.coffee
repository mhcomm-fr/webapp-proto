###*
 # @ngdoc function
 # @name webappProtoApp.service:PushNotificationSvc
 # @description
 # # PushNotificationSvc
 # Service of the webappProtoApp
###


angular.module('webappProtoApp')
  .factory('PushNotifSvc', ['$localStorage', '$window', '$q', ($localStorage, $window, $q) ->
    callbacks = {}
    
    
    initialize = () ->
      ###
        initialize the module, you have to call it before other methods
        initalize main callback, and re-register functions
      ###
      #callback for push notification
      if $window.navigator.mozSetMessageHandler 
        $window.navigator.mozSetMessageHandler('push', cbPushNotif)
      else 
        # No message handler
        console.error('cannot find window.navigator.mozSetMessageHandler')
      
      # register endpoint change
      if $window.navigator.mozSetMessageHandler
        $window.navigator.mozSetMessageHandler 'push-register', (e) ->
          ###
            function for re register push-notifications
          ###
          console.log('in callback of re-push')
          console.log('push-register received, I need to register my endpoint(s) again!')
          
          tmpLocalCallbacks = callbacks
          callbacks = {}
          tmpLocalStorage = $localStorage.enpoints
          $localStorage.enpoints = {} 
          for endpoint, name of tmpLocalStorage
            registerPushNotification(name, callbacks[name])
      else 
        # No message handler
        console.log('cannot find window.navigator.mozSetMessageHandler')
    
    
    isInLocalStorage = (name) ->
      ###
        @apiParam name name of endoint
        
        @apiSuccess True
        @apiError False
      ###
      for endpointName in $localStorage.enpoints
        if endpointName == name
          return true
      return false
      
    findInLocalStorage = (name) ->
      ###
        @apiParam name name of endoint
        
        @apiSuccess url of endpoint
        @apiError null
      ###
      for url, endpointName of $localStorage.enpoints
        if endpointName == name
          return url
      return null
    
    
    register = (endPointName, cbFunc) -> 
      ###
        register a new endpoint associated with name param, who call cbFunc when notify
      
        @apiParam endPointName  name of endoint
        @apiParam cbFunc  Function to call when endpoint is call
        
        @apiSuccess defer
        @apiError defer
      ###
      defered = $q.defer()
      if navigator.push 
        #todo : verify syntax
        if endPointName in callbacks
          console.log(endPointName +" is already register")
          defered.resolve()
          return defered.promise
        
        if isInLocalStorage(endPointName)
          callbacks[endPointName] = cbFunc
          console.log(endPointName +" is already register, but not in local memory. doing it")
          defered.resolve()
          return defered.promise
        
        req = navigator.push.register()
        req.onsuccess = (e) ->
          endpoint = req.result
          if ! $localStorage.enpoints 
            $localStorage.enpoints = {}
          
          $localStorage.enpoints[endpoint] = endPointName
          callbacks[endPointName] = cbFunc
          console.log("registering endoint " + endPointName + " with url " + endpoint)
          defered.resolve()
        
        req.onerror = (e) ->
          console.error("Error getting a new endpoint: " + JSON.stringify(e))
          defered.reject()
		 
      else 
        # No push on the DOM
        console.error('cannot find navigator.push')
        defered.reject()
      return defered.promise
        
    # not work yet
    unregister = (endPointName) ->
      ###
        unregister an endpoint already register, specified by endPointName.
      
        @apiParam endPointName  name of endoint
      ###
      defered = $q.defer()
      endpointUrl = findInLocalStorage(endPointName)
      if navigator.push and endpointUrl
        console.log('trying to untregister endpoint '+ endPointName)
        req = navigator.push.unregister(endpointUrl)
        
        req.onsuccess = (e) ->
          endpoint = req.result
          if endpoint != endpointUrl
            console.warning('both endpoint are not equals')
            
          $localStorage.enpoints[endpointUrl] = undefined
          callbacks[name] = undefined 
          console.log('endpoint '+ endPointName+ ' unregistered')
          defered.resolve()
        
        req.onerror = (e) ->
          console.error("Error unregistering the endpoint: " + JSON.stringify(e));
          defered.reject()
      
      else
        console.error('cannot find navigator.push')
        defered.resolve()
      
      return defered.promise
      
    
    cbPushNotif = (e) -> 
      ###
        main callback for all push notification.
        this method will call the callback given to the register method.
      ###
      endpoint = e.pushEndpoint
      version = e.version
      endPointName = $localStorage.enpoints[endpoint]
      endPointFunc = callbacks[endPointName]
      console.log('in push notif callback for '+ endPointName+ ' with version='+version)
      endPointFunc(version)
      
      
    return {
      register:register,
      unregister:unregister,
      initialize:initialize
    }
])
.run (PushNotifSvc) ->
  console.log('lauching run of pushNotificationSvc')
  
  PushNotifSvc.initialize()
  promise = PushNotifSvc.register "a", (version) -> 
    alert('callback for a with version '+ version) 
  
  promise = promise.then () ->
    PushNotifSvc.register "b", (version) -> 
      alert('callback for b with version '+ version)
  
  promise.then () -> 
    PushNotifSvc.unregister('a')
