browserify = require 'browserify-middleware'

@include = ->
  @get "/js/p2pdatastore.js": browserify ["crdt", "duplex",
    "./lib/rooms.js"
    "./lib/users.js"
    "./lib/timelines.js"
  ]

  @server.on "listening", -> 


  @on connection: ->
    o_ "connected"
    init_crdt_streams_over_socket_io(@socket)
    @emit "identification", @socket.handshake.address.address

  @shared "/js/p2pshared.js": ->
 
    root = if window? then window else global
    
    class root._SharedDoc
      stores = {}

      @set_store: (doc, class_name = null) ->   
        name = if @name is "SharedDoc"
            class_name
          else
            @name

        stores[name] = doc
        @__defineGetter__ "store", ->
          stores[name]

      @add: (data) ->
        new @ data.id, data

      @get: (id) ->
        new @ id

      @list: ->
        row.state for id, row of stores[@name].rows
 
      constructor: ->
        @store_name = @constructor.name
        @data = stores[@store_name].get @id
      
      set_data_fields: (data_fields...) ->
        @data_fields = data_fields
        _(@data_fields).each (prop_name) =>
          @__defineSetter__ prop_name, (value) =>
            # NEED TO UPDATE
            if  @data.get(prop_name) isnt value
              # UPDATE 
              @data.set prop_name, value

          @__defineGetter__ prop_name, =>
            @data.get prop_name

      set_data: (data) ->
        for k, v of data when @data_fields.indexOf(k) isnt -1
          @[k] = v

      set: (field, value) ->
        @data.set field, value


    root.crdt = require "crdt"
    duplex = require "duplex" 
    
    local_or_remote_module = (component) ->
      require if module?
          "./#{component}"
        else
          "./lib/#{component}.js"

    root.sharedDocs = [
      "Users"
      "Rooms"
      "Timelines"
    ]
    root.sharedDoc = {}

    for sdoc in sharedDocs
      root.sharedDoc[sdoc] = new crdt.Doc()
      
    root.Rooms = local_or_remote_module "rooms"
    Rooms.set_store sharedDoc.Rooms
    root.Users = local_or_remote_module "users"
    Users.set_store sharedDoc.Users
    root.Timelines = local_or_remote_module "timelines"
    Timelines.set_store sharedDoc.Timelines

    class SocketIOStreams
      constructor: (@socket) ->
        @channels = {}
 
      createStreamOnChannel: (channel) ->
        @socket.on channel, send_to_channel = (data) =>
          @channels[ channel ].emit "data", data
 
        @channels[ channel ] = duplex(
          _write = (data) =>
            @socket.emit channel, data
          _end = =>
            @socket?.removeListener? channel, send_to_channel
        )

    root.SocketIOStreams = SocketIOStreams
 
    root.init_crdt_streams_over_socket_io = (socket) ->
      for doc_name, doc of sharedDoc
        ds = doc.createStream()
        sio_streams = new SocketIOStreams(socket)
        sio_chan = sio_streams.createStreamOnChannel(doc_name)
        ds.pipe(sio_chan).pipe(ds)

  sharedDoc.Timelines.on "add", -> console.log "+T"
  sharedDoc.Timelines.on "row_update", -> console.log "~T"
  sharedDoc.Timelines.on "remove", -> console.log "-T"
