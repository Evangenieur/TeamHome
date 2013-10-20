app.controller "UserListCtrl", ($scope) ->
  console.log "User list"

app.controller "UserAddCtrl", ($scope, $location, localStorageService, ImageResize) ->

  $('input[type="file"]').ezdz 
    text: "Add my picture"
    accept: (file) ->
      console.log "file", file
      $scope.$apply -> 
        console.log $scope.me.avatar = (ImageResize $(".ezdz-accept img")[0], 150, 150, 90).src

  $scope.submit = ->

    localStorageService.add "me", JSON.stringify($scope.me)

    console.log "submit"
    $location.path "/channel"    
