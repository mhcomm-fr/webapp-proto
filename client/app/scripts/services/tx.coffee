###*
 # @ngdoc function
 # @name webappProtoApp.service:tx
 # @description
 # # tx
 # Service of the webappProtoApp
###


angular.module('webappProtoApp')
  .factory('tx', ($localStorage) ->

    if !$localStorage.tx?
      $localStorage.tx = []
    tx = $localStorage.tx

    return {
      tx: tx
      newMessageToTransmit: (content) ->
        tx_mess = {
          uid: content
        }
        tx.push(tx_mess)
    }
  )