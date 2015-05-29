'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the webappProtoApp
###

###
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor. Pellentesque auctor nisi id magna consequat sagittis. Curabitur dapibus enim sit amet elit pharetra tincidunt feugiat nisl imperdiet. Ut convallis libero in urna ultrices accumsan. Donec sed odio eros. Donec viverra mi quis quam pulvinar at malesuada arcu rhoncus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In rutrum accumsan ultricies. Mauris vitae nisi at sem facilisis semper ac in est.


Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi diam iaculis velit, id fringilla sem nunc vel mi. Nam dictum, odio nec pretium volutpat, arcu ante placerat erat, non tristique elit urna et turpis. Quisque mi metus, ornare sit amet fermentum et, tincidunt et orci. Fusce eget orci a orci congue vestibulum. Ut dolor diam, elementum et vestibulum eu, porttitor vel elit. Curabitur venenatis pulvinar tellus gravida ornare. Sed et erat faucibus nunc euismod ultricies ut id justo. Nullam cursus suscipit nisi, et ultrices justo sodales nec. Fusce venenatis facilisis lectus ac semper. Aliquam at massa ipsum. Quisque bibendum purus convallis nulla ultrices ultricies. Nullam aliquam, mi eu aliquam tincidunt, purus velit laoreet tortor, viverra pretium nisi quam vitae mi. Fusce vel volutpat elit. Nam sagittis nisi dui.
###


angular.module('webappProtoApp')
  .factory('messageLocal', ($localStorage) ->

    messages = []
    if !$localStorage.messages?
      $localStorage.messages = []
    else
       messages = $localStorage.messages

    return {
      newMessage: (content, user) ->
        mess = {
          timestamp: new Date()
          author: user.id
          content: content
        }
        $localStorage.messages.push(mess)
    }
  )
  .factory('messageSrv', ($resource) ->
    ress = $resource('http://localhost:9000/api/messages/:_id/')
    return ress
  )
  .factory('restMessage', ($resource) ->
    ress = $resource('http://localhost:9000/api/messages/:_id/')
    return {
      query: ress.query
      get: ress.get
      save: ress.save
      new: (data) ->
        return new ress(data)

    }
  )
  .factory('syncMessage', ($resource, $q, $localStorage, restMessage, connectionStatus, $timeout) ->
    ### Synced message resource TBD ###

    #connectionStatus.$on 'online', () ->
    #  # Check if there is message in TX to send


    if !$localStorage.messages?
      $localStorage.messages = []

    syncResource = {
      sync: () ->
        if $localStorage.tx and $localStorage.tx.length > 0
          console.log("Tx: "+$localStorage.tx.length+" elem to sync")

          for message in $localStorage.messages
            if message.uid in $localStorage.tx
              console.log("Sync msg: ", message)
              restMessage.new(message).$save().then(
                (value )->
                  message.sync = true
                  $localStorage.tx.splice($localStorage.tx.indexOf(value.uid), 1)
                (response)->
                 console.log("error: ", response)
              )


        else
          console.log("Tx:nothing to sync")



      query: (query) ->
        console.log('query message list')
        defered = $q.defer()
        defered.resolve([])
        return {$promise:defered.promise}

      save: (mess) ->
        console.log('Save message')
        defered = $q.defer()
        defered.resolve(mess)
        console.log(mess)
        mess.sync = false
        console.log(mess)
        $localStorage.messages.push(mess)

        ### Add message uid to tx table ###
        if !$localStorage.tx?
          $localStorage.tx = []
        tx = $localStorage.tx
        tx.push(mess.uid)
        tx.push(mess.uid)
        tx.push(mess.uid)

        return defered.promise

      get: (query) ->
        return null
      new: (data) ->
        return new Message(data)

    }

    class Message
      constructor: (data) ->
        # Do construction
        console.log('Create new message')
        angular.extend(this, data)
      $save: () ->
        return syncResource.save(this)


    poller = () ->
      #console.log("Sync message resource")
      syncResource.sync()
      $timeout(poller, 60000)

    poller()

    return syncResource
  )