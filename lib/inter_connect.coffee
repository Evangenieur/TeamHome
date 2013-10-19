webSocketClient = require 'socket.io-client'
module.exports = (server, home) ->
    
  o_ "Interconnection".blue
  socket = webSocketClient.connect server, query: "from=#{home.name}"
  
  socket.on "connect", => 
    console.log "Connect #{home.name} -> InterServer".green

  socket.on "disconnect", =>
    console.log "Disconnect #{home.name} X InterServer".red



