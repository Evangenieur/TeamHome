app.directive 'contentItem', ($compile) ->
    imageTemplate = """
    <div class="entry-photo"
        <a href="{{content.url}}">
            <img ng-src="{{content.url}}" style="width: 200px; height:200px">
        </a>
    </div>
    """
    videoTemplate = """
    <div class="entry-photo"
        <a href="{{content.url}}">
            <video alt="entry photo" style="width: 450px; height:200px" controls>
              <source ng-src="{{content.url}}" type="{{content.content_type}}"></source>
            </video>
        </a>
    </div>
    """

    getTemplate = (contentType) ->
        template = ''

        switch contentType
            when 'image'
                template = imageTemplate
            when 'video'
                template = videoTemplate

        template

    linker = (scope, element, attrs) ->
        scope.rootDirectory = 'files/'
        console.log "content?", scope.content
        unless scope.content.content_type?
            element.html("{{content.text}}").show()    
        else
            element.html(getTemplate(scope.content.type)).show()

        $compile(element.contents())(scope)
    
    restrict: "E"
    rep1ace: true
    link: linker
    scope: 
        content:'='
