app.factory 'socket', ($rootScope) ->
  socket = io.connect() #, transports: ['xhr-polling']
  console.log "connected?", socket
  
  socket: socket.socket
  on: (event, cb) ->
    socket.on event, (args...) ->
      $rootScope.$apply ->
        cb.apply socket, args
  emit: (event, data, ack) ->
    if typeof data is "function"
      ack = data
      data = ""

    socket.emit event, data, (args...) ->
      $rootScope.$apply ->
        ack?.apply socket, args
