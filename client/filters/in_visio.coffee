app.filter "in_visio", ->
  console.log "in_visio"
  (users) ->
    return if not users or not users.length
    _(users).filter (user) ->
      user.state?.visio

