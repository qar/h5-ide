#############################
#  View(UI logic) for design
#############################

define [ 'event', 'text!./module/design/template.html', 'constant', 'backbone', 'jquery', 'handlebars' ], ( ide_event, template, constant ) ->

    DesignView = Backbone.View.extend {

        el          : '#tab-content-design'

        initialize  : ->

        render   : () ->
            console.log 'design render'
            #render
            this.$el.html template
            #push DESIGN_COMPLETE
            this.trigger 'DESIGN_COMPLETE'

        listen   : ( model ) ->
            #set this.model
            this.model = model
            #listen model
            this.listenTo this.model, 'change:snapshot',     @writeOldDesignHtml
            this.listenTo ide_event,  'SHOW_DESIGN_OVERLAY', @showDesignOverlay
            this.listenTo ide_event,  'HIDE_DESIGN_OVERLAY', @hideDesignOverlay

        html : ->
            data =
                resource : $( '#resource-panel' ).html()
                property : $( '#property-panel' ).html()
                canvas   : $( '#canvas-panel'   ).html()
                overlay  : $( '#overlay-panel'  ).html()
            data

        writeOldDesignHtml : ( event ) ->
            console.log 'writeOldDesignHtml'
            return if _.isNumber event.attributes.snapshot
            #
            $( '#canvas-panel' ).one( 'DOMNodeInserted', '.canvas-svg-group', this, _.debounce( this.canvasChange, 200, true ))
            #
            $( '#resource-panel' ).html this.model.get( 'snapshot' ).resource
            $( '#canvas-panel'   ).html this.model.get( 'snapshot' ).canvas
            $( '#overlay-panel'  ).html this.model.get( 'snapshot' ).overlay
            #
            if $.trim( $( '#overlay-panel'  ).html() ) isnt '' then @showDesignOverlay() else @hideDesignOverlay()
            ###
            this.$el.empty().html this.model.get 'snapshot'
            $( '#property-panel' ).html this.model.get( 'snapshot' ).property
            $( '#property-panel' ).empty()
            ###
            null

        canvasChange : ( event ) ->
            console.log 'canvas:listen DOMNodeInserted'
            console.log MC.data.current_tab_type
            if MC.data.current_tab_type is 'OLD_APP' or MC.data.current_tab_type is 'OLD_STACK'
                ide_event.trigger ide_event.SWITCH_WAITING_BAR
                MC.data.current_tab_type = null
            null

        showDesignOverlay : ( state ) ->
            console.log 'showDesignOverlay, state = ' + state

            # state include:
            # 1. open fail
            # 2. process( starting, stopping, terminating, updating, changed fail )

            $item = $( '#overlay-panel' )

            # 1. add class
            $item.addClass 'design-overlay'

            # 2. switch state
            switch state
                when 'OPEN_TAB_FAIL'                          then $item.html MC.template.openTabFail()
                when constant.APP_STATE.APP_STATE_STARTING    then $item.html MC.template.appStarting()
                when constant.APP_STATE.APP_STATE_STOPPING    then $item.html MC.template.appStopping()
                when constant.APP_STATE.APP_STATE_TERMINATING then $item.html MC.template.appTerminating()
                when constant.APP_STATE.APP_STATE_UPDATING    then $item.html MC.template.appUpdating { 'rate' : MC.process[ MC.data.current_tab_id ].flag_list.rate, 'steps' : MC.process[ MC.data.current_tab_id ].flag_list.steps, 'dones' : MC.process[ MC.data.current_tab_id ].flag_list.dones }
                when 'CHANGED_FAIL'                           then $item.html MC.template.appChangedfail()
                when 'UPDATING_SUCCESS'                       then $item.html MC.template.appUpdatedSuccess()

            if state is 'OPEN_TAB_FAIL' and MC.data.current_tab_id.split('-')[0] is 'app'
                $( '#btn-fail-reload' ).one 'click', ( event ) ->
                    #ide_event.trigger ide_event.PROCESS_RUN_SUCCESS, MC.open_failed_list[ MC.data.current_tab_id ].tab_id, MC.open_failed_list[ MC.data.current_tab_id ].region
                    #test123
                    #MC.open_failed_list[ MC.data.current_tab_id ].is_fail = false
                    #
                    null

            else if state is 'CHANGED_FAIL'
                $( '#btn-changedfail' ).one 'click', ( event ) ->
                    ide_event.trigger ide_event.APPEDIT_UPDATE_ERROR
                    ide_event.trigger ide_event.HIDE_DESIGN_OVERLAY

            else if state is 'UPDATING_SUCCESS'
                $( '#btn-updated-success' ).one 'click', ( event ) ->
                    ide_event.trigger ide_event.APPEDIT_2_APP, MC.data.process[ MC.data.current_tab_id ].id, MC.data.process[ MC.data.current_tab_id ].region

            else if state is constant.APP_STATE.APP_STATE_UPDATING and MC.data.process[ MC.data.current_tab_id ].flag_list.is_pending
                $( '.overlay-content-wrap' ).find( '.progress' ).hide()
                $( '.overlay-content-wrap' ).find( '.process-info' ).hide()

            else if state is constant.APP_STATE.APP_STATE_UPDATING and MC.data.process[ MC.data.current_tab_id ].flag_list.is_inprocess
                $( '.overlay-content-wrap' ).find( '.progress' ).show()
                $( '.overlay-content-wrap' ).find( '.process-info' ).show()

        hideDesignOverlay : ->
            console.log 'hideDesignOverlay'

            $item = $( '#overlay-panel' )

            # 1. remove class
            $item.removeClass 'design-overlay'

            # 2. remove html
            $item.empty() if $.trim( $item.html() ) isnt ''

            null

    }

    return DesignView
