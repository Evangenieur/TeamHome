app.controller "TestApp", ($scope, socket, sharedDoc) ->
  console.log "TestApp", $scope, socket
  window.$scope = $scope

  init_crdt_streams_over_socket_io(socket)

  # LiveRelaod
  firstCnx = not socket.socket.connected
  console.log "firstCnx", socket.socket.connected
  socket.on "connect", ->
    window.location.reload() unless firstCnx 
    firstCnx = false
    console.log "connection", socket.socket.sessionid
  socket.on "identification", (ip) ->    
    Users.add $scope.me = 
      id: ip
      type: "client"
      ua: navigator.userAgent
      username: "Anon" + Math.round((Math.random() * 500))
  
  socket.on "identifiaction", (data) ->
    Users.add data
    console.log ">ident", data

  # sharedDocs
  sharedDocs.forEach (doc_name) ->
    window[doc_name] = $scope[doc_name] = sharedDoc doc_name
    switch doc_name
      when "Users"        
        update_users = ->
          $scope.users = (user.state for id, user of $scope.Users.rows)

        $scope[doc_name].on "add", update_users
        $scope[doc_name].on "remove", update_users

