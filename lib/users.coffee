module.exports = 
  class Users extends _SharedDoc
    constructor: (@id, data= {}) ->
      super
      @set_data_fields "username", "avatar", "state"
      @set_data data