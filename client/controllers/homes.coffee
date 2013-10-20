app.controller "HomeListCtrl", ($scope) ->
  console.log "Home list"

app.controller "HomeAddCtrl", ($scope, socket, $location, ImageResize) ->
  console.log "Home add"
  $scope.home = myHome

  $('input[type="file"]').ezdz 
    text: "Add a picture"
    accept: (file) ->
      console.log "file", file
      $scope.$apply -> 
        $scope.home.avatar = (ImageResize $(".ezdz-accept img")[0], 150, 150, 90).src



  $scope.submit = ->
    console.log "submit"
    socket.emit "home_setup", $scope.home
    $location.path "/users/add"