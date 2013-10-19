app.controller "HomeListCtrl", ($scope) ->
  console.log "Home list"

app.controller "HomeAddCtrl", ($scope, socket, $location) ->
  console.log "Home add"
  $scope.home = myHome

  $('input[type="file"]').ezdz 
    text: "Add a picture"
    accept: (file) ->
      console.log "file", file
      $scope.home.avatar = file.data

  $scope.submit = ->
    console.log "submit"
    socket.emit "home_setup", $scope.home
    $location.path "/users/add"