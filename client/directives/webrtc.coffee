app.factory 'webrtc', ($rootScope) ->
  peerConnectionConfig = 
    iceServers: [
      { url: "stun:stun.l.google.com:19302"}
    ]

  parser = new UAParser()
  ua = parser.getResult()
  
  if ua.browser.name.match(/Chrom(e|ium)/)
    peerConnectionConfig.iceServers.push 
      url: "turn:test@watsh.tv:3478"
      credential: "test"
  else if ua.browser.name.match(/Firefox/)
    if parseFloat(ua.browser.version) >= 24.00
      peerConnectionConfig.iceServers.push 
        url: "turn:watsh.tv:3478"
        credential: "test"
        username: "test"
    else
      return not_supported: true

  try 
    window.webrtc = new WebRTC
      peerConnectionConfig: peerConnectionConfig
      url: window.location.host
      debug: true
  catch e
    return not_supported: true

  webrtc.on "message", (msg) ->
    events.out_message? msg

  webrtc.on "peerStreamAdded", (peer) ->
    peer.stream.onended = ->
      console.log "Stream ended"
    peer.stream.onremovetrack = ->
      console.log "Track ended"
    $rootScope.$apply ->
      events.on_remote_camera? peer

  webrtc.on "peerStreamRemoved", (args...) ->
    console.log "peerStreamRemoved", arguments

  window.webrtc_a = events = 
    started: false
    users: []
    waiting_msgs: []
    users_to_call: []

    on_my_camera: null
    on_remote_camera: null
    out_message: null
    
    init: (cam_resolution = "small") ->
      webrtc.startLocalMedia {
          video: 
            mandatory: 
              switch cam_resolution
                when "small"
                  maxWidth: 320
                  maxHeight: 240
                when "medium"
                  maxWidth: 640
                  maxHeight: 480
          audio: true

        }, (err, stream) ->
          #myVideo = attachMediaStream stream
          console.log "CAM INIT"
          if err 
            console.log err
            return 

          $rootScope.$apply ->
            events.on_my_camera?.call events, stream #myVideo
            events.ready()

    in_message: (msg) ->
      #console.log "in_message, @started?", @started
      unless @started
        @waiting_msgs.push msg
        return

      peers = webrtc.getPeers msg.from
      #console.log "on message", msg.type, peers.length
      unless peers.length
        @add_peer msg.from
        peers = webrtc.getPeers msg.from

      ###
      if msg.type is "offer"
        peer = webrtc.createPeer 
          id: msg.from
        peer.handleMessage msg
      else
      ###
      _(peers).each (peer) ->
        peer.handleMessage msg

    on: (args...) ->
      webrtc.on args...
    join: (user_id) ->            
      if webrtc.localStream
        @add_peer user_id
      else
        @users.push user_id
    
    ready: ->
      console.log "READY", "waiting msgs", @waiting_msgs.length
      @started = true

      while user_id = @users.pop()
        @add_peer user_id

      while user_id = @users_to_call.pop()
        console.log "Calling", user_id
        @call_peer user_id

      while msg = @waiting_msgs.shift()
        @in_message msg

    add_peer: (user_id) ->
      unless  webrtc.getPeers(user_id)?.length
        webrtc.createPeer
          id: user_id

    call_peer: (user_id) ->
      console.log "Calling #{user_id}"
      peers = webrtc.getPeers user_id
      console.log "peers", peers
      _(peers).each (peer) ->
        console.log ">Calling #{user_id}"
        peer.start()    
    
    stop: ->
      @started = false
      peers = webrtc.getPeers()
      _(peers).each (peer) ->
        peer.end()              

    toggleCam: ->
      video = webrtc.localStream.getVideoTracks()[0]
      video.enabled = not video.enabled

    toggleMic: ->
      audio = webrtc.localStream.getAudioTracks()[0]
      audio.enabled = not audio.enabled

    start: (users) ->
      if webrtc.localStream
        @on_my_camera? webrtc.localStream
        @users = @users.concat users
        @users_to_call = @users_to_call.concat users
        @ready()
      else 
        # TODO 
        @start_cam()