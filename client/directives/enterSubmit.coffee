app.directive 'enterSubmit', ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    submit = false

    $(element).on({
      keydown: (e) ->
        submit = false

        if (e.which is 13 && !e.shiftKey)
          submit = true
          e.preventDefault()

      keyup: () ->
        if submit
          console.log attrs.enterSubmit, scope
          scope.$eval( attrs.enterSubmit )

          # flush model changes manually
          scope.$digest()
    })
