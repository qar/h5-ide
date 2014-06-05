###

###

define [ 'underscore', 'backbone' ], () ->

    class Event

        constructor : ->
            _.extend this, Backbone.Events

        #
        OPEN_PROPERTY          : 'OPEN_PROPERTY'
        FORCE_OPEN_PROPERTY    : "FORCE_OPEN_PROPERTY"
        REFRESH_PROPERTY       : "REFRESH_PROPERTY"
        RELOAD_AZ              : 'RELOAD_AZ'

        #tabbar
        UPDATE_DESIGN_TAB      : 'UPDATE_DESIGN_TAB'

        #status bar & ta
        HIDE_STATUS_BAR        : 'HIDE_STATUS_BAR'
        UPDATE_STATUS_BAR      : 'UPDATE_STATUS_BAR'
        UPDATE_TA_MODAL        : 'UPDATE_TA_MODAL'
        UNLOAD_TA_MODAL        : 'UNLOAD_TA_MODAL'
        TA_SYNC_START          : 'TA_SYNC_START'
        TA_SYNC_FINISH         : 'TA_SYNC_FINISH'

        # User Input Change Event
        ENABLE_RESOURCE_ITEM   : 'ENABLE_RESOURCE_ITEM'
        DISABLE_RESOURCE_ITEM  : 'DISABLE_RESOURCE_ITEM'

        # property
        SHOW_PROPERTY_PANEL    : 'SHOW_PROPERTY_PANEL'
        PROPERTY_REFRESH_ENI_IP_LIST : 'PROPERTY_REFRESH_ENI_IP_LIST'
        PROPERTY_DISABLE_USER_DATA_INPUT : 'PROPERTY_DISABLE_USER_DATA_INPUT'

        #app/stack operation
        START_APP              : 'START_APP'

        #app/stack state
        UPDATE_APP_STATE       : 'UPDATE_APP_STATE'

        #canvas event save stack/app by ctrl+s
        CANVAS_SAVE            : 'CANVAS_SAVE'

        UPDATE_STATE_STATUS_DATA  :  'STATE_STATUS_DATA_UPDATE'
        UPDATE_STATE_STATUS_DATA_TO_EDITOR  :  'UPDATE_STATE_STATUS_DATA_TO_EDITOR'
        STATE_EDITOR_SAVE_DATA : 'STATE_EDITOR_SAVE_DATA'

        #state editor
        SHOW_STATE_EDITOR        : 'SHOW_STATE_EDITOR'
        STATE_EDITOR_DATA_UPDATE : 'STATE_EDITOR_DATA_UPDATE'

        onListen : ( type, callback, context ) ->
            this.once type, callback, context

        onLongListen : ( type, callback, context ) ->
            this.on type, callback, context

        offListen : ( type, function_name ) ->
            if function_name then this.off type, function_name else this.off type

    event = new Event()

    event
