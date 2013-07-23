####################################
#  Controller for design/property/rtb module
####################################

define [ 'jquery',
         'text!/module/design/property/rtb/template.html',
         'event'
], ( $, template, ide_event ) ->

    #
    current_view  = null
    current_model = null

    #add handlebars script
    template = '<script type="text/x-handlebars-template" id="property-rtb-tmpl">' + template + '</script>'
    #load remote html template
    $( 'head' ).append template

    #private
    loadModule = ( uid, type, current_main ) ->

        #
        MC.data.current_sub_main = current_main

        #
        require [ './module/design/property/rtb/view', './module/design/property/rtb/model' ], ( view, model ) ->

            #
            if current_view then view.delegateEvents view.events

            #
            current_view  = view
            current_model = model

            #view
            view.model    = model
            #render

            model.getRoute( uid )

            view.render()

            view.on 'SET_ROUTE', ( uid, data, routes ) ->

                model.setRoutes uid, data, routes

            view.on 'SET_NAME', ( uid, name ) ->

                model.setName uid, name

            view.on 'SET_MAIN_RT', ( uid ) ->

                model.setMainRT uid

                model.getRoute( uid )

                view.render()

            view.on 'REFRESH_PROPERTY', () ->

                model.getRoute( uid )

                view.render()


    unLoadModule = () ->
        current_view.off()
        current_model.off()
        current_view.undelegateEvents()
        #ide_event.offListen ide_event.<EVENT_TYPE>
        #ide_event.offListen ide_event.<EVENT_TYPE>, <function name>

    #public
    loadModule   : loadModule
    unLoadModule : unLoadModule