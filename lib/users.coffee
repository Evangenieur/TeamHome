module.exports = 
  class Users extends _SharedDoc
    constructor: (@id, data= {}) ->
      super
      @set_data_fields "username", "family_member_type", "avatar", "ua", "state"
      @set_data data
      @family_member_type or= "Dad"
      @state or= {}

    online: ->
      @state.online = true
      @set "state", @state

    offline: ->
      @state.offline = false
      @set "state", @state

    visio: (flag) ->
      @state.visio = flag
      @set "state", @state

    calling: ->
      @state.calling = true
      @set "state", @state


