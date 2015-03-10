###*
 # @ngdoc function
 # @name webappProtoApp.controller:MainCtrl
 # @description
 # # LoginCtrl
 # Controller of the webappProtoApp
###




angular.module('webappProtoApp')
  .controller 'LoginCtrl', ($scope, userSrv, $state) ->
        
        
    $scope.credentials = {}
    $scope.loginFailed = false

    $scope.login = () ->
      {username, password} = $scope.credentials
      logged = userSrv.login(username, password)
      if logged
        $state.go('user.main', {userId: logged.id})
      else
        $scope.loginFailed = true                    
        