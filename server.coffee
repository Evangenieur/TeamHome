SERVICE_NAME = "TeamHome"
#INTER_SERVER = "http://teamho.me/"
fs = require "fs"
STORE_PATH = "./store/"
HOME_FILE = STORE_PATH + "home.json"

require "colors"
require "./config/globals"
{port: PORT} = (require("./config/arguments") SERVICE_NAME)

try
  home = JSON.parse fs.readFileSync HOME_FILE
catch e
  home = 
    name: null
    avatar: null

require("zappajs") PORT, ->

  @server.on "listening", -> 
    o_ "#{SERVICE_NAME} server listening on".rainbow.inverse, "#{PORT}".green
    #require("./lib/inter_connect") INTER_SERVER, home

  @use "static", logger: "dev"
  @io.set "log level", 0
  @set "view engine": "jade"

  @get "/": -> 
    @render "index.jade",
      service_name: SERVICE_NAME
      my_home: JSON.stringify(home)

  @get "/views/:view.html": ->
    @render @params.view

  @on "home_setup": ->
    console.log "HOME SETUP", @data
    home = @data

    fs.writeFile HOME_FILE, JSON.stringify(@data)

  @include "./lib/shareddoc"
  @include "./lib/upload"
  @include "./config/builders"
  @include "./lib/messaging"
