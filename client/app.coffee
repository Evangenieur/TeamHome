console.log "App"
window.app = angular.module("TeamHome", ["ngRoute", "LocalStorageModule"])
  .config ($routeProvider) ->
    $routeProvider.when "/test",
      templateUrl: "test.html"
      controller: "TestApp"