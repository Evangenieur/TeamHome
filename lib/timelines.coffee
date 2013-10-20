module.exports = 
  class Timelines extends _SharedDoc
    constructor: (@id, data= {}) ->
      super
      @set_data_fields "datum", "date_published", "user", "channel"
      @set_data data
