####################################
#  Controller for navigation module
####################################

define [ 'jquery', 'text!/module/navigation/template.html', '/module/navigation/model.js', 'event' ], ( $, template, model, ide_event ) ->

    #private
    loadModule = () ->

        #add handlebars script
        template = '<script type="text/x-handlebars-template" id="navigation-tmpl">' + template + '</script>'

        #load remote html template
        $( template ).appendTo 'head'

        #load remote /module/navigation/view.js
        require [ './module/navigation/view', 'UI.tooltip', 'UI.accordion', 'hoverIntent' ], ( View ) ->

            #view
            view       = new View()
            view.model = model
            #refresh view
            view.render()

            #listen vo set change event
            model.on 'change:app_list', () ->
                console.log 'change:app_list'
                #push event
                ide_event.trigger ide_event.RESULT_APP_LIST, null
                #refresh view
                view.render()
                #call
                model.stackListService()

            model.on 'change:stack_list', () ->
                console.log 'change:stack_list'
                #push event
                ide_event.trigger ide_event.RESULT_STACK_LIST, null
                #refresh view
                view.render()
                #call
                model.regionEmptyList()

            model.on 'change:region_empty_list', () ->
                console.log 'change:region_empty_list'
                #push event
                ide_event.trigger ide_event.RESULT_EMPTY_REGION_LIST, null
                #refresh view
                view.render()
                #call
                model.describeRegionsService()

            model.on 'change:region_list', () ->
                console.log 'change:region_list'
                #push event
                ide_event.trigger ide_event.RESULT_REGION_LIST, null
                #refresh view
                view.render()

            #model
            model.appListService()

    unLoadModule = () ->
        #view.remove()

    #public
    loadModule   : loadModule
    unLoadModule : unLoadModule