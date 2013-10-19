module.exports = 
  class Rooms extends _SharedDoc
    constructor: (@id, data= {}) ->
      super
      @set_data_fields "name", "homes", "timeline"
      @set_data data