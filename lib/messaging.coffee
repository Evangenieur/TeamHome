@include = ->
  @on connection: ->
    console.log "> in connection"