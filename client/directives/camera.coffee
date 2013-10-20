app.directive 'camera', ->
  restrict: "E"
  replace: true
  template: "<video></video>"
  transclude: true
  scope: 
    stream: "="
    audio: "="
    show: "="
  link: (scope, element, attrs) ->
    
    scope.$watch "show", (neww, old, scope) ->
      video = element[0]
      console.log "on show change", neww, old
      video.style.display = if neww then "" else "none"

    scope.$watch "audio", (neww, old, scope) ->
      video = element[0]
      video.muted = !neww
    
    scope.$watch "stream", (neww, old, scope) ->
      video = element[0]
      #return unless neww
      console.log "watch stream", arguments
      unless neww
        $(video).css "display", "none"
        return              

      $(video).css "display", ""

      try 
        if URL and URL.createObjectURL
          video.src = URL.createObjectURL(neww)
        else if element.srcObject
          video.srcObject = neww
        else if element.mozSrcObject
          video.mozSrcObject = neww
      catch e
        console.log "Error", e

      video.muted = true