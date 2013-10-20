app.controller "MainCtrl", ($scope, $location, socket, sharedDoc, localStorageService, webrtc) ->

  console.log "MainCtrl", myHome, $scope, socket, localStorage
  $scope.myHome = myHome
  #$scope.socket = socket
  
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
    console.log "sharedDoc", doc_name
    $scope[doc_name] = sharedDoc doc_name
    switch doc_name
      when "Users"        
        update_users = ->
          $scope.users = Users.list()

        $scope[doc_name].on "add", update_users
        $scope[doc_name].on "remove", update_users
        #$scope[doc_name].on "row_update", update_users
      when "Timelines"
        update_timelines = ->
          $scope.timelines = Timelines.list()

          $("html, body").scrollTop $(document).height()
          false

        $scope[doc_name].on "add", update_timelines
        $scope[doc_name].on "remove", update_timelines
        #$scope[doc_name].on "row_update", update_timelines

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
  
  socket.on "connect", ->
    console.log "SOCKETID", socket.socket.sessionid
    $scope.me.state= 
      id: socket.socket.sessionid
      online: true

  $scope.$watch "me.username", (n,o) ->
    console.log "watch me"
    unless _(n).isEqual o
      #socket.emit "me", $scope.me, =>
      #  console.log "Sending me", $scope.me
      localStorageService.add "me", JSON.stringify($scope.me)

  if not myHome?.name or not $scope.me?.username
    $location.path "/home"

  ### WebRTC In ###
  socket.on "message", (msg) ->
    console.log "WEBRTC.IN", msg.type, msg
    Users.get(msg.from).calling()
    webrtc.in_message msg

  ### Quit Visio
  $scope.$on '$routeChangeStart', (next, current) ->
    if $scope.me.state.visio and not current.$$route.originalPath.match /visio/
      $scope.me.visio false
   ###

  ### View Methods ###
  $scope.isActive = (page) ->
    if window.location.hash[1..-1] is page
      "active"
    else 
      if page is "/visio" and _($scope.users).find((user) -> user.state?.visio)
        "call"
      else        
        ""

  $scope.logout = ->
    console.log "logout"
    localStorageService.remove("me")
    window.location.reload()

  $scope.setup = ->
    if not myHome?.name
      $location.path "/homes/add"
    else if not $scope.me?.username
      $location.path "/users/add"
    else
      alert "WTF ?"
    console.log $scope

  ### Sub Views Methods ###
  $scope.get_user = (id, field) ->
    Users.get(id)[field]

  $scope.get_users_online = ->
    _(Users.list()).filter (user) -> user.state?.online

