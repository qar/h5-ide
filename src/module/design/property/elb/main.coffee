####################################
#  Controller for design/property/elb module
####################################

define [ 'jquery',
         'text!./template.html',
         'text!./app_template.html',
         'event'
], ( $, template, app_template, ide_event ) ->

    #
    current_view  = null
    current_model = null

    #add handlebars script
    template     = '<script type="text/x-handlebars-template" id="property-elb-tmpl">' + template + '</script>'
    app_template = '<script type="text/x-handlebars-template" id="property-elb-app-tmpl">' + app_template + '</script>'
    #load remote html template
    $( 'head' ).append template
    $( 'head' ).append app_template

    #private
    loadModule = ( uid, current_main, tab_type ) ->
        console.log 'elb main, tab_type = ' + tab_type

        MC.data.current_sub_main = current_main


        if tab_type is 'OPEN_APP'
            loadAppModule uid
            return

        require [ './module/design/property/elb/view',
                  './module/design/property/elb/model',
                  './module/design/property/sglist/main'
                  ], ( view, model, sglist_main ) ->

            # added by song
            model.clear({silent: true})

            #
            if current_view then view.delegateEvents view.events

            #
            current_view  = view
            current_model = model

            view.model    = model

            # model.set 'type', 'stack'

            view.on 'ELB_NAME_CHANGED', ( value ) ->
                model.setELBName uid, value
                # Set title
                ide_event.trigger ide_event.PROPERTY_TITLE_CHANGE, value

            view.on 'SCHEME_SELECT_CHANGED', ( value ) ->
                elbComponent = model.setScheme uid, value

                defaultVPC = false
                if MC.aws.aws.checkDefaultVPC()
                    defaultVPC = true
                
                # Trigger an event to tell canvas that we want an IGW
                if value isnt 'internal' and !defaultVPC
                    ide_event.trigger ide_event.NEED_IGW, elbComponent

                return true

            view.on 'HEALTH_PROTOCOL_SELECTED', ( value ) ->
                model.setHealthProtocol uid, value

            view.on 'HEALTH_PORT_CHANGED', ( value ) ->
                model.setHealthPort uid, value

            view.on 'HEALTH_PATH_CHANGED', ( value ) ->
                model.setHealthPath uid, value

            view.on 'HEALTH_INTERVAL_CHANGED', ( value ) ->
                model.setHealthInterval uid, value

            view.on 'HEALTH_TIMEOUT_CHANGED', ( value ) ->
                model.setHealthTimeout uid, value

            view.on 'UNHEALTHY_SLIDER_CHANGE', ( value ) ->
                model.setHealthUnhealth uid, value

            view.on 'HEALTHY_SLIDER_CHANGE', ( value ) ->
                model.setHealthHealth uid, value

            view.on 'LISTENER_ITEM_CHANGE', ( value ) ->
                model.setListenerAry uid, value

            view.on 'LISTENER_CERT_CHANGED', ( value ) ->
                model.setListenerCert uid, value

            view.on 'REFRESH_CERT_PANEL_DATA', ( value ) ->
                currentCert = model.getCurrentCert uid
                currentCert && view.refreshCertPanel currentCert

            view.on 'REMOVE_AZ_FROM_ELB', ( value ) ->
                model.removeAZFromELB uid, value

            view.on 'ADD_AZ_TO_ELB', ( value ) ->
                model.addAZToELB uid, value

            view.on 'REFRESH_SG_LIST', () ->
                sglist_main.refresh()

            #model
            model.init uid

            #render
            view.render model.attributes

            # Set title
            ide_event.trigger ide_event.PROPERTY_TITLE_CHANGE, model.attributes.component.name

            sglist_main.loadModule model

    loadAppModule = ( uid ) ->

        require [ './module/design/property/elb/app_view',
                  './module/design/property/elb/app_model',
                  './module/design/property/sglist/main'
        ], ( view, model, sglist_main ) ->

            # added by song
            model.clear({silent: true})

            #
            if current_view then view.delegateEvents view.events

            current_view  = view
            current_model = model

            #view
            view.model    = model

            # model.set 'type', 'app'

            model.init uid
            view.render()

            # Set title
            ide_event.trigger ide_event.PROPERTY_TITLE_CHANGE, model.attributes.name

            sglist_main.loadModule model, true

    unLoadModule = () ->
        if !current_view then return
        current_view.off()
        current_model.off()
        current_view.undelegateEvents()

    #public
    loadModule   : loadModule
    unLoadModule : unLoadModule
