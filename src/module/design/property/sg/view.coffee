#############################
#  View(UI logic) for design/property/sg
#############################

define [ 'event', 'backbone', 'jquery', 'handlebars' ], ( ide_event ) ->

    InstanceView = Backbone.View.extend {

        el       : $ document
        tagName  : $ '.property-details'

        template : Handlebars.compile $( '#property-sg-tmpl' ).html()

        events   :
            'click .secondary-panel .back' : 'openInstance'

        render     : () ->
            console.log 'property:sg render'
            $( '.property-details' ).html this.template this.model.attributes
            #
            $('#sg-secondary-panel').fadeIn 200
            $('#sg-secondary-panel .sg-title input').focus()

        openInstance : () ->
            console.log 'openInstance'
            ide_event.trigger ide_event.OPEN_INSTANCE

    }

    view = new InstanceView()

    return view