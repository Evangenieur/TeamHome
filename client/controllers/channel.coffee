app.controller "ChannelCtrl", ($scope, socket) ->
  console.log "In ChannelCtrl"
  $scope.current_channel = ""
  do newChatEntry = ->
    window.chat = $scope.chat = Timelines.add
      id: cuid()
      datum: text: ""
      date_started: (new Date()).getTime()
      user: $scope.me.id
      channel: ""

  $scope.send = ->
    return unless $scope.chat.datum.text
    console.log "Send"
    $scope.chat.date_published = (new Date()).getTime()
    newChatEntry()

    $("html, body").animate
      scrollTop: $(document).height()
    , "slow"
    false

  $scope.$watch "chat.datum.text", (n,o) ->
    $scope.chat.set "datum", $scope.chat.datum

  $scope.rawText = ->
    $scope.chat.datum.text

  $scope.progress = 0
  file = null
  fileReader = null

  # UUID
  # http://blog.snowfinch.net/post/3254029029/uuid-v4-js
  createUuid = ->
    uuid = ""
    for i in [0..32]
      rand = Math.random() * 16 | 0
      uuid += "-" if i in [8, 12, 16, 20]
      uuid += (
        if i is 12 then 4
        else if i is 16 then rand & 3 | 8
        else rand
      ).toString 16
    uuid

  socket.emit "getfile", (res) ->
    console.log "got file", res

  socket.on "upload:more", (data) ->
    console.log "got socket upload:more", data
    return unless file and fileReader
    $scope.progress = data.percent
    place = data.place * 524288
    fileReader.readAsBinaryString file.slice place, place + Math.min 524288, file.size - place

  socket.on "upload:done", ->
    console.log "got socket upload:done", file

    Timelines.add
      id: cuid()
      datum: text: "#{ file.name }: /files/#{ file.id }"
      date_started: (new Date()).getTime()
      user: $scope.me.id
      channel: ""

    $scope.progress = 0
    file = null
    fileReader = null

  $scope.fileChanged = (el) ->
    return console.log "file locked" if file
    $scope.progress = 0
    return unless el.files.length

    file = el.files[0]
    file.id = createUuid()
    fileReader = new FileReader()

    fileReader.onload = (ev) ->
      console.log "fileReader load", ev
      socket.emit "upload:data",
        id: file.id
        data: ev.target.result

    socket.emit "upload:start", file
    no

