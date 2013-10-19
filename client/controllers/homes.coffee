app.controller "HomeListCtrl", ($scope, socket, sharedDoc, localStorageService) ->
  console.log "Home list"

app.controller "HomeAddCtrl", ($scope, socket, sharedDoc, localStorageService) ->
  console.log "Home add"

  $('input[type="file"]').ezdz text: "Add a picture"

