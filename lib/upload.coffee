exec = require("child_process").exec
fs = require "fs"

@include = ->

  tempDir = "./temp/"
  filesDir = "./files/"
  files = {}

  @get "/upload": -> 
    @render "upload.jade",
      service_name: "TeamHome"

  @on "upload:start": (file) ->
    console.log "upload:start", file
    id = file.id
    files[ id ] = file
    file.data = ""
    file.downloaded = 0

    place = 0
    tempFile = tempDir + id

    try
      stat = fs.statSync tmpFile
      if stat.isFile()
        file.downloaded = stat.size
        place = stat.size / 524288
    catch e

    fs.open tempFile, "a", 0o0755, (err, fd) =>
      return console.log err if err
      
      file.handler = fd
      @emit "upload:more",
        place: place
        percent: 0

  @on "upload:data": (data) ->
    id = data.id
    file = files[ id ]
    file.downloaded += data.data.length;
    file.data += data.data

    if file.downloaded is file.size
      fs.write file.handler, file.data, null, "binary", (err) =>
        tempFile = tempDir + id
        destFile = filesDir + id
        input = fs.createReadStream tempFile
        output = fs.createWriteStream destFile
        input.pipe output
        input.on "end", =>
          fs.unlink tempFile, =>
            # exec "ffmpeg -i " + destFile  + " -ss 01:30 -r 1 -an -vframes 1 -f mjpeg " + destFile + ".jpg", (err) =>
            @emit "upload:done"#, image: destFile + ".jpg"

    else if file.data.length > 10485760 
      fs.write file.handler, file.data, null, "binary", (err) =>
        file.data = ""
        @emit "upload:more",
          place: file.downloaded / 524288
          percent: file.downloaded / file.size * 100

    else
      @emit "upload:more",
        place: file.downloaded / 524288
        percent: file.downloaded / file.size * 100
