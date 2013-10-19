app.controller "MainCtrl", ($scope, $location, socket, sharedDoc, localStorageService) ->

  console.log "MainCtrl", myHome, $scope, socket, localStorage
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
          $scope.users = Users.list()

        $scope[doc_name].on "add", update_users
        $scope[doc_name].on "remove", update_users

  #### MY IDENTITY ######
  $scope.me = Users.add do ->
      try
        if me = localStorageService.get("me")
          return JSON.parse(me)
      catch e 
        localStorageService.remove("me")

      me = 
        id: cuid()
        username: null
        avatar: null
        ua: (new UAParser()).getResult()

      localStorageService.add "me", JSON.stringify($scope.me)

      me
  

  $scope.$watch "me.username", (n,o) ->
    console.log "watch me"
    unless _(n).isEqual o
      #socket.emit "me", $scope.me, =>
      #  console.log "Sending me", $scope.me
      localStorageService.add "me", JSON.stringify($scope.me)

  if not myHome?.name or not $scope.me?.username
    $location.path "/home"
  else
    $location.path "/channel"

  ### View Methods ###
  $scope.setup = ->
    if not myHome?.name
      $location.path "/homes/add"
    else if not $scope.me?.username
      $location.path "/users/add"
    else
      alert "WTF ?"
    console.log $scope
