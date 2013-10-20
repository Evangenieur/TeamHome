app.controller "UserListCtrl", ($scope) ->
  console.log "User list"
  $scope.get_online_class = (online) ->
    if online then "label-success" else "label-default"
  
  $scope.get_online_text = (online) ->
    if online then "online" else "offline"

  $scope.families = [
    {
      name: "My Family"
      avatar: $scope.myHome.avatar
      users: $scope.users
    }
    {
      name: "Other Family"
      avatar: $scope.myHome.avatar
      users: $scope.users
    }
  ]

app.controller "UserAddCtrl", ($scope, $location, localStorageService, ImageResize) ->

  $('input[type="file"]').ezdz 
    value: $scope.me.avatar
    text: "Add my picture"
    accept: (file) ->
      console.log "file", file
      $scope.$apply -> 
        console.log $scope.me.avatar = 
          (ImageResize $(".ezdz-accept img")[0], 200, 200, 90).src

  $scope.submit = ->

    localStorageService.add "me", JSON.stringify($scope.me)

    console.log "submit"
    $location.path "/channel"
