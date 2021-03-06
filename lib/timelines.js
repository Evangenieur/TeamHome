// Generated by CoffeeScript 1.6.3
(function() {
  var Timelines,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Timelines = (function(_super) {
    __extends(Timelines, _super);

    function Timelines(id, data) {
      this.id = id;
      if (data == null) {
        data = {};
      }
      Timelines.__super__.constructor.apply(this, arguments);
      this.set_data_fields("datum", "date_published", "user", "channel");
      this.set_data(data);
    }

    return Timelines;

  })(_SharedDoc);

}).call(this);
