app.filter "matchCurrentChannel", ->
  console.log "matchCurrentChannel"
  (messages, current_channel) ->
    return unless messages
    _(messages).filter (msg) ->
      return unless msg
      msg?.datum?.text and msg.channel is current_channel

