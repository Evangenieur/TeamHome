SERVICE_NAME = "Inter TeamHome"
require "colors"
require "./config/globals"
{port: PORT} = (require("./config/arguments") SERVICE_NAME)


require("zappajs") PORT, ->
  @server.on "listening", -> o_ "#{SERVICE_NAME} server listening on".rainbow.inverse, "#{PORT}".green
  @use "static", logger: "dev"
  @io.set "log level", 0
  @set "view engine": "jade"

  @on connection: -> 
    o_ ">Cnx", @socket.handshake.query.from.green, @socket.handshake.address

  @on disconnect: ->
    o_ "XCnx", @socket.handshake.query.from.green, @socket.handshake.address
