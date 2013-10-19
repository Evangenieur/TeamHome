app.controller "UserListCtrl", ($scope, socket, sharedDoc, localStorageService) ->
  console.log "User list"

app.controller "UserAddCtrl", ($scope, socket, sharedDoc, localStorageService) ->
  console.log "User add"

  $('input[type="file"]').ezdz text: "Add my picture"

