console.log "App"
window.app = angular.module("TeamHome", ["ngRoute", "LocalStorageModule"])
  .config ($routeProvider) ->

    $routeProvider.when "/",
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
