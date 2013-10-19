app.controller "UserListCtrl", ($scope) ->
  console.log "User list"

app.controller "UserAddCtrl", ($scope, $location, localStorageService) ->

  $('input[type="file"]').ezdz 
    text: "Add my picture"
    accept: (file) ->
      console.log "file", file
      $scope.me.avatar = file.data

  $scope.submit = ->

    localStorageService.add "me", JSON.stringify($scope.me)

    console.log "submit"
    $location.path "/"    
