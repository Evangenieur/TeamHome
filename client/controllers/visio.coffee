app.controller "VisioCtrl", ($scope, $timeout, webrtc, socket) ->
  console.log "In VisioCtrl", webrtc
  $scope.cam = 
    available: false
    activated: false
    enabled: false

  $scope.mic =
    enabled: false 
    activated: false

  if not webrtc.not_supported

    $scope.cam.available = true 

  webrtc.on_my_camera = (my_video) ->
    console.log "ON_MY_CAM o/"
    me_in_list = _($scope.users).find (user) -> user.id is $scope.me.id
    me_in_list.stream = my_video
    me_in_list.audio = false
    $scope.cam.activated = true
    $scope.cam.enabled = true
    $scope.mic.activated = true
    $scope.mic.enabled = true

    webrtc.users_to_call = _($scope.users).chain()
      .filter((user) -> user.state?.online and user.id isnt $scope.me.id)
      .map((user) -> user.id)
      .value()
    console.log "Users TO Call", webrtc.users_to_call

    $scope.me.visio(true)

  webrtc.on_remote_camera = (peer) ->
    console.log "\\o/ REMOTE CAM", arguments
    remote_in_list = _($scope.users).find (user) -> user.id is peer.id
    remote_in_list.stream = peer.stream
    $timeout ->
        remote_in_list.audio = true
      , 1000

  webrtc.out_message = (msg) ->
    console.log "WEBRTC.OUT", msg.type
    socket.emit "message", msg

  $scope.toggleCam = ->
    if webrtc.started
      $scope.cam.enabled = webrtc.toggleCam()
      me_in_list = _($scope.users).find (user) -> user.id is $scope.me.id
      if $scope.cam.enabled
        me_in_list.cam_enabled = true
      else
        me_in_list.cam_enabled = false
    else
      webrtc.init "small"

  $scope.toggleMic = ->
    console.log "toggleMic"
    
    if $scope.mic.enabled = webrtc.toggleMic()
      $scope.previous_volume = player.getVolume()
      console.log "getting previous_volume", $scope.previous_volume
      player.setVolume(low_volume)
    else
      console.log "setting previous_volume", $scope.previous_volume
      player.setVolume( $scope.previous_volume )

  $scope.toggleCam()

  $scope.homes = [
    {
      name: "Toto"
      avatar: null
      users: $scope.users
    }
    {
      name: "Toto"
      avatar: null
      users: $scope.users
    }
  ]



