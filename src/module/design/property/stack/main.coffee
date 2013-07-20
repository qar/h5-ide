####################################
#  Controller for design/property/stack module
####################################

define [ 'jquery',
         'text!/module/design/property/stack/template.html',
         'event'
], ( $, template, ide_event ) ->

    #
    current_view = null

    #private
    loadModule = ( current_main ) ->

        #
        MC.data.current_sub_main = current_main

        #add handlebars script
        template = '<script type="text/x-handlebars-template" id="property-stack-tmpl">' + template + '</script>'
        #load remote html template
        $( 'head' ).append template

        #
        require [ './module/design/property/stack/view', './module/design/property/stack/model' ], ( view, model ) ->

            #
            current_view  = view

            #view
            view.model    = model
            #render
            renderPropertyPanel = () ->
                view.model.getStack()
                view.render view.model.attributes

            renderPropertyPanel()

            view.on 'STACK_NAME_CHANGED', (name) ->
                console.log 'stack name changed and refresh'
                MC.canvas_data.name = name
                renderPropertyPanel()

            view.on 'DELETE_STACK_SG', (uid) ->
                model.deleteSecurityGroup uid

            view.on 'RESET_STACK_SG', (uid) ->
                model.resetSecurityGroup uid
                view.render view.model.attributes


    unLoadModule = () ->
        current_view.off()

    #public
    loadModule   : loadModule
    unLoadModule : unLoadModule