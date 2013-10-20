app.factory "ImageResize", ->
  (source_img_obj, width, height, quality) ->
     cvs = document.createElement('canvas')
     console.log "r", ratio = source_img_obj.naturalWidth / source_img_obj.naturalHeight
     console.log "w", cvs.width = width
     console.log "h", cvs.height = height / ratio
     ctx = cvs.getContext("2d")
     ctx.drawImage(source_img_obj, 0, 0, source_img_obj.width, source_img_obj.height, 0, 0, cvs.width, cvs.height)
     newImageData = cvs.toDataURL("image/jpeg", quality)
     result_image_obj = new Image()

     result_image_obj.src = newImageData
     console.log "resized img", result_image_obj.src
     result_image_obj

