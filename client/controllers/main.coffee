app.controller "MainCrtl", ($scope, socket, sharedDoc, localStorageService) ->
  console.log "MainCrtl", $scope, socket, localStorage

  # LiveRelaod
  firstCnx = not socket.socket.connected
  console.log "firstCnx", socket.socket.connected
  socket.on "connect", ->
    window.location.reload() unless firstCnx 
    firstCnx = false
    console.log "connection", socket.socket.sessionid  

  ##### INIT #####
  window.$scope = $scope

  init_crdt_streams_over_socket_io(socket)

  # sharedDocs
  sharedDocs.forEach (doc_name) ->
    $scope[doc_name] = sharedDoc doc_name
    switch doc_name
      when "Users"        
        update_users = ->
          console.log "users", Users, Users.list()
          $scope.users = Users.list()

        $scope[doc_name].on "add", update_users
        $scope[doc_name].on "remove", update_users

  #### MY IDENTITY ######
  console.log "me ?", localStorageService.get("me")
  $scope.me = Users.add do ->
      try
        if me = localStorageService.get("me")
          return JSON.parse(me)
      catch e 
        localStorageService.remove("me")
      me = 
        id: cuid()
        username: "Anon"
        avatar: ""
        ua: (new UAParser()).getResult()

      localStorageService.add "me", JSON.stringify($scope.me)

      me


  console.log "me", $scope.me

  $scope.$watch "me", (n,o) ->
    unless _(n).isEqual o
      #socket.emit "me", $scope.me, =>
      #  console.log "Sending me", $scope.me
      localStorageService.add "me", JSON.stringify($scope.me)


