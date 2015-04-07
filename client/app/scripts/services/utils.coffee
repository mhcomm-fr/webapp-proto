'use strict'

###*
 # @ngdoc function
 # @name webappProtoApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the webappProtoApp
###


angular.module('webappProtoApp')
.factory('utils', () ->
  return {
  genUUID: () ->
    d = new Date().getTime()

    uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = (d + Math.random() * 16) % 16 | 0
      d = Math.floor(d / 16)
      return (if c == 'x' then r else (r & 0x3 | 0x8)).toString(16)

    return uuid
  }
)