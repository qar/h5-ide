#############################
#  View(UI logic) for design/canvas
#############################

define [ 'event', 'canvas_layout', 'constant', 'MC.canvas', 'backbone', 'jquery', 'handlebars', 'UI.notification' ], ( ide_event, canvas_layout, constant ) ->

    CanvasView = Backbone.View.extend {

        el       : $( '#canvas' )

        initialize : ->
            #listen
            this.listenTo ide_event, 'SWITCH_TAB', ()->
                canvas_layout.listen()

            this.listenTo ide_event, 'UPDATE_RESOURCE_STATE', ()->
                canvas_layout.listen()

            #bind event
            $( document )
                .on( 'CANVAS_NODE_SELECTED',        '#svg_canvas', this.showProperty )
                .on( 'CANVAS_ASG_VOLUME_SELECTED',  '#svg_canvas', this.showASGVolumeProperty )
                .on( 'CANVAS_INSTANCE_SELECTED',    '#svg_canvas', this.showInstanceProperty )
                .on( 'CANVAS_LINE_SELECTED',        '#svg_canvas', this.lineSelected )
                .on( 'CANVAS_SAVE',                 '#svg_canvas', this, this.save )
                .on( 'CANVAS_NODE_CHANGE_PARENT CANVAS_GROUP_CHANGE_PARENT CANVAS_OBJECT_DELETE CANVAS_LINE_CREATE CANVAS_COMPONENT_CREATE CANVAS_EIP_STATE_CHANGE CANVAS_BEFORE_DROP CANVAS_PLACE_NOT_MATCH CANVAS_PLACE_OVERLAP CANVAS_ASG_SELECTED CANVAS_ZOOMED_DROP_ERROR CANVAS_BEFORE_ASG_EXPAND CHECK_CONNECTABLE_EVENT ',   '#svg_canvas', _.bind( this.route, this ) )

        render   : ( template ) ->
            console.log 'canvas render'
            $( '#canvas' ).html template
            #
            ide_event.trigger ide_event.DESIGN_SUB_COMPLETE

        reRender   : ( template ) ->
            console.log 're-canvas render'
            if $.trim( this.$el.html() ) is 'loading...' then $( '#canvas' ).html template

        showInstanceProperty : ( event, uid ) ->
            # Directly open the instance property
            ide_event.trigger ide_event.OPEN_PROPERTY, 'component', uid

        showProperty : ( event, uid ) ->
            console.log 'showProperty, uid = ' + uid
            # In App / AppEdit mode, when clicking Instance. Switch to ServerGroup
            type  = "component"
            state = MC.canvas.getState()

            component = MC.canvas_data.component[uid]
            if component and component.type is constant.AWS_RESOURCE_TYPE.AWS_EC2_Instance
                if state is "appedit" or (state is "app" and  "" + component.number isnt "1")
                    type = "component_server_group"

            ide_event.trigger ide_event.OPEN_PROPERTY, type, uid

        showASGVolumeProperty : ( event, uid ) ->
            console.log 'showProperty, uid = ' + uid
            ide_event.trigger ide_event.OPEN_PROPERTY, 'component_asg_volume', uid

        lineSelected : ( event, line_id ) ->
            ide_event.trigger ide_event.OPEN_PROPERTY, 'line', line_id

        route : ( event, option ) ->
            # Dispatch the event to model
            this.trigger event.type, event, option

        save : () ->
            #save by ctrl+s
            ide_event.trigger ide_event.CANVAS_SAVE

    }

    return CanvasView
