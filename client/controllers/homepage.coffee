app.controller "HomepageCtrl", ($scope, $route, $location) ->
  $scope.page = "homes"
  console.log "HomePageCtrl", $scope
  $scope.setup_txt = 
    if not myHome?.name
      "Add a new home"
    else if not $scope.me?.username
      "Identify Me"
    else
      $location.path "/"