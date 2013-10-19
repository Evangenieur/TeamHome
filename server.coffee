SERVICE_NAME = "TeamHome"
INTER_SERVER = "http://teamho.me/"

require "colors"
require "./config/globals"
{port: PORT} = (require("./config/arguments") SERVICE_NAME)

home = 
  name: "MyHome"
  avatar: "/img/avatar.jpg"

require("zappajs") PORT, ->

  @server.on "listening", -> 
    o_ "#{SERVICE_NAME} server listening on".rainbow.inverse, "#{PORT}".green
    require("./lib/inter_connect") INTER_SERVER, home

  @use "static", logger: "dev"
  @io.set "log level", 0
  @set "view engine": "jade"

  @get "/": -> 
    @render "index.jade",
      service_name: SERVICE_NAME

  @get "/views/:view.html": ->
    @render @params.view


  @include "./lib/shareddoc"
  @include "./lib/upload"
  @include "./config/builders"
