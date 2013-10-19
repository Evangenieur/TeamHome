app.factory 'sharedDoc', (socket, $rootScope) ->
  shared = {}
  (doc_name) ->
    doc = new crdt.Doc()
    console.log "new sharedDoc", doc_name, doc.rows

    apply_scope = ->
      for id, row of doc.rows
        row._json = JSON.stringify row

    doc.on "remove", apply_scope
    doc.on "add", apply_scope
    doc.on "row_update", apply_scope

    ### Socket.io Pipe to channel {doc_name} ###
    doc_stream = doc.createStream()
    sio_streams = new SocketIOStreams(socket)
    sio_chan = sio_streams.createStreamOnChannel(doc_name)
    doc_stream.pipe(sio_chan).pipe(doc_stream)

    socket.on "disconnect", off_cnx = ->
      doc_stream.end()
      doc.removeAllListeners()
      #socket.removeListener "disconnect", off_cnx

    doc