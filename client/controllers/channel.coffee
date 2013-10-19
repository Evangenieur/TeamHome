app.controller "ChannelCtrl", ($scope) ->
  console.log "In ChannelCtrl"
  $scope.current_channel = ""
  do newChatEntry = ->
    window.chat = $scope.chat = Timelines.add
      id: cuid()
      datum: text: ""
      date_started: (new Date()).getTime()
      user: $scope.me.id
      channel: ""

  $scope.get_user = (id, field) ->
    Users.get(id)[field]

  $scope.send = ->
    return unless $scope.chat.datum.text
    console.log "Send"
    $scope.chat.date_published = (new Date()).getTime()
    newChatEntry()

  $scope.$watch "chat.datum.text", (n,o) ->
    $scope.chat.set "datum", $scope.chat.datum
