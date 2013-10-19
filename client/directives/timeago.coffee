app.directive 'timeago', ($timeout) ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    updateTime = ->
      if attrs.timeago
        time = scope.$eval(attrs.timeago)
        elem.text(jQuery.timeago(time))
        #$timeout(updateTime, 15000)
    scope.$watch attrs.timeago, updateTime
