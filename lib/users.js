// Generated by CoffeeScript 1.6.3
(function() {
  var Users,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Users = (function(_super) {
    __extends(Users, _super);

    function Users(id, data) {
      this.id = id;
      if (data == null) {
        data = {};
      }
      Users.__super__.constructor.apply(this, arguments);
      this.set_data_fields("username", "avatar", "state");
      this.set_data(data);
    }

    return Users;

  })(_SharedDoc);

}).call(this);