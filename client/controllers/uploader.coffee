app.controller "AppUploader", ["$scope", "socket", ($scope, socket) ->

  $scope.progress = 0
  file = null
  fileReader = null

  # UUID
  # http://blog.snowfinch.net/post/3254029029/uuid-v4-js
  uuid = ->
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

  socket.on "upload:more", (data) ->
    console.log "got socket upload:more", data
    return unless file and fileReader
    $scope.progress = data.percent
    place = data.place * 524288
    fileReader.readAsBinaryString file.slice place, place + Math.min 524288, file.size - place

  socket.on "upload:done", ->
    console.log "got socket upload:done"
    $scope.progress = 100
    file = null
    fileReader = null

  $scope.fileChanged = (el) ->
    return console.log "file locked" if file
    $scope.progress = 0
    return unless el.files.length
    file = el.files[0]
    file.id = uuid()

  $scope.upload = ->
    return unless file?

    console.log "upload file", file
    fileReader = new FileReader()

    fileReader.onload = (ev) ->
      console.log "fileReader load", ev
      socket.emit "upload:data",
        id: file.id
        data: ev.target.result

    socket.emit "upload:start", file
]
