if location.hostname is "localhost" or location.hostname is "macbook-air-de-jay.local"
  s = document.createElement("script")
  s.type = "text/javascript"
  s.src = "http://macbook-air-de-jay.local:35729/livereload.js?snipver=1"
  $("head").append s

window.app = angular.module("TeamHome", ["ngRoute", "LocalStorageModule"])
  .config ($routeProvider) ->
    $routeProvider.when "/home",
      templateUrl: "/views/homepage.html"
      controller: "HomepageCtrl"

    $routeProvider.when "/homes/",
      templateUrl: "/views/homes-list.html"
      controller: "HomeListCtrl"

    $routeProvider.when "/homes/add",
      templateUrl: "/views/homes-add.html"
      controller: "HomeAddCtrl"

    $routeProvider.when "/users/",
      templateUrl: "/views/users-list.html"
      controller: "UserListCtrl"

    $routeProvider.when "/users/add",
      templateUrl: "/views/users-add.html"
      controller: "UserAddCtrl"

    $routeProvider.when "/channel",
      templateUrl: "/views/channel.html"
      controller: "ChannelCtrl"
